1. Install PostgreSQL on Fedora 43
sudo dnf install postgresql-server postgresql-contrib

2. Initialize the database cluster
sudo postgresql-setup --initdb  # creates the default cluster in: /var/lib/pgsql/data

3. Enable + start PostgreSQL    # I don't want postgresql to start automatically on startup, i would rather have it start manually on demand.
sudo systemctl enable postgresql
sudo systemctl start postgresql

4. Create the PostgreSQL user “john”    # Generic 'John Doe' on purpose, placeholder
sudo -iu postgres
createuser john
psql -c "ALTER USER john WITH PASSWORD 'password';"
exit


5. Change authentication from trust → md5       # but keep postgres as trust
sudo nano /var/lib/pgsql/data/pg_hba.conf
# Allow postgres user to connect without password
local   all             postgres                                trust

# All other users must authenticate with md5
local   all             all                                     md5
host    all             all             127.0.0.1/32            md5
host    all             all             ::1/128                 md5


6. Reload PostgreSQL to apply changes
sudo systemctl reload postgresql
