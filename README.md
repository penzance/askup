# AskUp: POC single app
## Question Market incorporated into AskUp

This is proof of concept code that brings the underlying data into AskUp 
(removing dependency on Question Market). To get it running, you'll need to get
your AskUp database set up like your Question Market database; basically, you'll 
need to run migrations, and then optionally copy data from your Question Market 
question_groups, questions, and answers tables if you don't want to start over.
 
1. It's a good idea to make a backup of your development.sqlite3 file, e.g.:
          
          cp db/development.sqlite3 db/development-backup.sqlite3

2. Run migrations. (This is needed to add the question groups table to AskUp.)

          bundle exec rake db:migrate

3. _(optional)_ Dump your questions, answers, and question groups from your
Question Market (QM) database into your AskUp (AU) database.
    * Open the *QM database* in the sqlite3 shell, then dump the tables.
  
            sqlite3 db/development.sqlite3   # in question-market
            .output qm_questions_dump.txt
            .dump questions
    
    * Drop the old table *in AU* and reload it with the dump files.
  
            sqlite3 db/development.sqlite3   # in askup
            drop questions
            .read qm_questions_dump.txt   # from question-market dir/project