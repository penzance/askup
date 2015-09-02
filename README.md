# AskUp

AskUp is an application designed to improve learning and retention.

## Configuration

### Ruby, rails
* App has been developed thus far using Ruby 2.1.4 and Rails 4.2.0

### Settings files
* Create .yml versions of all config/*.yml.example files
* generate secret keys (see secrets.yml.example)
** `rake secret | pbcopy` (or equivalent) and put the secret key into secure ENV variable (e.g. `export ASKUP_SECRET_KEY_BASE=...`)

### Database
* install postgres
* run postgres (set up agent, or run manually)
* rake db:create:all
* rake db:migrate -- or use taps gem if required to pull records from another (e.g. sqlite3) db

### Devise (user authentication)
* [Devise setup](https://github.com/plataformatec/devise#getting-started)

### Static assets
* If using in production, set up static assets served from e.g. nginx / apache

# Upgrading from Question Market backend

If you want to bring your data from Question Market into AskUp, you'll need to get
your AskUp database set up like your Question Market database; basically, you'll 
need to run migrations, and then optionally copy data from your Question Market 
question_groups, questions, and answers tables if you don't want to start over.
 
1. It's a good idea to make a backup of your development.sqlite3 file, e.g.:
          
          cp db/development.sqlite3 db/development-backup.sqlite3

2. Run migrations. (This is needed to add the qsets table to AskUp.)

          bundle exec rake db:migrate

3. _(optional)_ Dump your questions, answers, and qsets from your
Question Market (QM) database into your AskUp (AU) database.
    * Open the *QM database* in the sqlite3 shell, then dump the tables.
  
            sqlite3 db/development.sqlite3   # in question-market
            .output qm_questions_dump.txt
            .dump questions
    
    * Drop the old table *in AU* and reload it with the dump files.
  
            sqlite3 db/development.sqlite3   # in askup
            drop questions
            .read qm_questions_dump.txt   # from question-market dir/project