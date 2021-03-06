/**
 * Copyright (C) 2016. No part of this file may be replicated without the
 *   explicit written consent of all authors of this project.
 */

'use strict';

var winston = require('winston');

module.exports = function(envConfig) {

    winston.transports.Console.level = 'debug';
    //Remove the default console transport
    winston.remove(winston.transports.Console);

    winston.add(winston.transports.File, {
        filename: envConfig.logging.filename,
        timestamp: function(){return new Date().toString();} ,
        level: envConfig.logging.level
    });

    /**
     * If we are running locally don't remove the console so we can see the output
     */
    if(envConfig.name === 'development'){
        winston.add(winston.transports.Console, {
            timestamp: function(){return new Date().toString();},
            level: 'silly', //Show all logs when developing locally
            colorize: true
        });
    }

    return winston;

};