### Modify main.sh with your own login usernames for VU MIF Cloud for each VM(database, client, web).

### Then run ./main.sh which will automatically:
* Install all prerequisites.
* Create ssh key(if one doesn't exist).
* Create 3 VMs.
* Add IPs to ansible host file.
* Setup a ansible vault.
* Run the ansible playbooks.
* Setup database with mysql and create custom user for website
* Install chrome on client VM