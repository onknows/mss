= Mailbox Self Service application

Very simple interface for test mail server based on Exim, Dovecot. Mailboxes are defined using two MySQL tables: domains and mailboxes. Creating a test mailbox is as simple as inserting a record in a table.

####Run
`bundle install`  
`rackup`  
go to [localhost:9292](http://localhost:9292) in your browser.  


