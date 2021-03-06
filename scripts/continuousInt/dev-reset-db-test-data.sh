# Navigate to the database script directory
export DB_HOST=tsmdata.lvm.org
cd /var/lib/jenkins/workspace/reset-db-test-data/scripts/database

# Delete the database
mysql --host=$DB_HOST --user=test --password=testing < 00LVMDropDbScript.sql

# Create the database
mysql --host=$DB_HOST --user=test --password=testing < 01LVMCreateDbScript.sql

# Create the tables
mysql --host=$DB_HOST --user=test --password=testing lvm < 02LVMCreateTableScript.sql
mysql --host=$DB_HOST --user=test --password=testing lvm < 02LVMCreateTableZipCodes.sql

# Alter tables
mysql --host=$DB_HOST --user=test --password=testing lvm < 03LVMAlterTableDOEOccupationScript.sql
mysql --host=$DB_HOST --user=test --password=testing lvm < 03LVMAlterTableScript.sql

# Run Validation Test
mysql --host=$DB_HOST --user=test --password=testing lvm < LVMValidateAlterTableInsert.sql

# Add test data
mysql --host=$DB_HOST --user=test --password=testing lvm < 04LVMUpdateExitTableSproc.sql
mysql --host=$DB_HOST --user=test --password=testing lvm < 04LVMUpdateMatchSproc.sql
mysql --host=$DB_HOST --user=test --password=testing lvm < 04LVMUpdateMatchTableSproc.sql
mysql --host=$DB_HOST --user=test --password=testing lvm < 04LVMUpdateMeetingTableSproc.sql
mysql --host=$DB_HOST --user=test --password=testing lvm < 04LVMUpdatePersonAvailabilityTableSproc.sql
mysql --host=$DB_HOST --user=test --password=testing lvm < 04LVMUpdatePersonSproc.sql
mysql --host=$DB_HOST --user=test --password=testing lvm < 04LVMUpdatePersonTableSproc.sql
mysql --host=$DB_HOST --user=test --password=testing lvm < 04LVMUpdatePersonPreferencesTableSproc.sql
mysql --host=$DB_HOST --user=test --password=testing lvm < 04LVMUpdateStudentAnswersTableSproc.sql
mysql --host=$DB_HOST --user=test --password=testing lvm < 04LVMUpdateStudentAssessmentTableSproc.sql
mysql --host=$DB_HOST --user=test --password=testing lvm < 04LVMUpdateStudentComputerSkillsTableSproc.sql
mysql --host=$DB_HOST --user=test --password=testing lvm < 04LVMUpdateStudentContactInfoTableSproc.sql
mysql --host=$DB_HOST --user=test --password=testing lvm < 04LVMUpdateStudentDependentsTableSproc.sql
mysql --host=$DB_HOST --user=test --password=testing lvm < 04LVMUpdateStudentDisabiltyAccommodationsTableSproc.sql
mysql --host=$DB_HOST --user=test --password=testing lvm < 04LVMUpdateStudentGoalsTableSproc.sql
mysql --host=$DB_HOST --user=test --password=testing lvm < 04LVMUpdateStudentPublicAssistanceTableSproc.sql
mysql --host=$DB_HOST --user=test --password=testing lvm < 04LVMUpdateStudentTableSproc.sql
mysql --host=$DB_HOST --user=test --password=testing lvm < 04LVMUpdateStudentWorkExperienceTableSproc.sql
mysql --host=$DB_HOST --user=test --password=testing lvm < 04LVMUpdateTutorHoursTableSproc.sql
mysql --host=$DB_HOST --user=test --password=testing lvm < 04LVMUpdateTutorTableSproc.sql
mysql --host=$DB_HOST --user=test --password=testing lvm < 05LVMDeleteTestDataSproc.sql
mysql --host=$DB_HOST --user=test --password=testing lvm < 06LVMAddExitRemoveMatchSproc.sql
mysql --host=$DB_HOST --user=test --password=testing lvm < 06LVMAddMatchSproc.sql
mysql --host=$DB_HOST --user=test --password=testing lvm < 06LVMAddMeetingSproc.sql
mysql --host=$DB_HOST --user=test --password=testing lvm < 06LVMAddStudentSproc.sql
mysql --host=$DB_HOST --user=test --password=testing lvm < 06LVMAddTutorSproc.sql
mysql --host=$DB_HOST --user=test --password=testing lvm < 07LVMAddTestStudentTutor.sql

# Validate test data was inserted
mysql --host=$DB_HOST --user=test --password=testing lvm < LVMValidateTestDataInsert.sql

