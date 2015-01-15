# AskUp

AskUp is an application designed to improve learning and retention.

## Configuration

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
