/**
 * Copyright (C) 2016. No part of this file may be replicated without the
 *   explicit written consent of all authors of this project.
 * 
 * Created By: Michael Rodrigues
 */

'use strict';

var _ = require('underscore');

module.exports = function (logging, database, statusCodes) {
    var cleanseData = function (data) {
        delete data['isTestData'];
        return data;
    };
    
    return {
        getTutor: function (req, res, next) {
            var query = 'SELECT t.*, p.*, p.id as pid, t.id as tid, s.name as siteName, ' +
                        '       nl.language as languageName, e.ethnicity as ethnicity, ' +
                        '       r.referral as doeReferralName, l.referral as lvmReferralName, ' +
                        '       es.status as employmentStatusName, o.occupation as doeOccupationName ' +
                        'FROM Person p, Tutor t, Sites s, DOENativeLanguage nl, Ethnicity e, ' +
                        '     DOEReferral r, LVMReferral l, DOEOccupation o, EmploymentStatus es ' +
                        'WHERE p.id = t.person and ' +
                        '      p.site = s.id and ' +
                        '      p.nativeLanguage = nl.id and' +
                        '      p.ethnicity = e.id and ' +
                        '      p.doeReferral = r.id and ' + 
                        '      p.lvmReferral = l.id and ' +
                        '      p.doeEmployStatus = es.id and ' +
                        '      p.doeOccupation = o.id ',
                queryVals = [];
            
            if (req.params.pid) {
                query += '      and p.id = ?';
                queryVals.push(req.params.pid);
            }
            
            // If not an admin (affiliate = 0), then specify the affiliate's site in the query to limit results
            if (req.session.user.affiliate) {
                query += ' and p.site = ? ';
                queryVals.push(req.session.user.affiliate);
            }
            
            database.query({
                sql: query,
                values: queryVals
            }, function (error, results, fields) {
                if (error) { 
                    logging.error('error fetching tutor', {
                        name: req.params.name,
                        user: req.session.user.username,
                        error: error
                    });
                    return res.status(statusCodes.INTERNAL_SERVER_ERROR).json([null]);
                }
                results = _.map(results, cleanseData);
                if (results.length == 1) {
                    results = results[0];
                }
                res.json(results);
            });
        },
        
        addTutor: function (req, res, next) {
            // Pending UI fields
        },
        
        updateTutor: function (req, res, next) {
            // Pending UI fields
        },
        
        exitTutor: function (req, res, next) {
            // Validate fields:
            if (!req.params.pid || !_.isNumber(req.params.pid) || !req.body.date ||
                !_.isDate(req.body.date) || !req.body.doeReason || !req.body.lvmReason) {
                return res.status(statusCodes.BAD_REQUEST_STATUS).send('Not all required fields are present.');
            }
            
            var currentDate = new Date();
            
            database.query({
                sql: 'INSERT INTO lvm.Exit (person, date, doeReason, lvmReason, dateAdded, dateModified) VALUES(?, ?, ?, ?, ?, ?);',
                values: [req.params.pid, req.body.date, req.body.doeReason, req.body.lvmReason, currentDate, currentDate]
            }, function (error, results, fields) {
                if (error) {
                    logging.error('adding exit reason for tutor failed', {
                        name: req.params.name,
                        user: req.session.user.username,
                        error: error
                    });
                    return res.status(statusCodes.INTERNAL_SERVER_ERROR).json({success: false});
                }
                return res.json(results);
            });
        },
        
        autocomplete: function (req, res, next) {
            var queryValue = req.params.name + '%'; // add wildcard on end
            
            database.query({
                sql: 'SELECT p.id as pid, t.id as tid, p.firstName, p.lastName, ' +
                     '       p.primaryServiceType, s.name as site ' +
                     'FROM Tutor t, Person p, Sites s ' +
                     'WHERE t.person = p.id and ' +
                     '      p.site = s.id and ' +
                     '      (p.firstName like ? or ' +
                     '        p.lastName like ? or ' +
                     '        p.email like ?) ' +
                     // If not an admin (affiliate = 0), then specify the affiliate's site in the query to limit results
                     (req.session.user.affiliate ? ' and p.site = ? ' : '') +
                     'LIMIT 10;',
                values: [queryValue, queryValue, queryValue, req.session.user.affiliate]
            }, function (error, results, fields) {
                if (error) { 
                    logging.error('tutor autocomplete failed', {
                        name: req.params.name,
                        user: req.session.user.username,
                        error: error
                    });
                    return res.status(statusCodes.INTERNAL_SERVER_ERROR).json([]);
                }
                return res.json(results);
            });
        }
    };
};