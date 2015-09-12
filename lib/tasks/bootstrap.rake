namespace :bootstrap do
  desc "Add the default admin user"
  task :default_admin_user => :environment do
    User.create(
        :first_name => 'Ask',
        :last_name => 'Up',
        :email => 'auadmin@example.com',
        :password => 'password',
        :role => 'admin'
    )
  end

  desc "Add the default test user"
  task :default_test_user => :environment do
    User.create(
        :first_name => 'Inquisitive',
        :last_name => 'Queryhands',
        :email => 'testuser@example.com',
        :password => 'password',
        :role => 'contributor'
    )
  end

  desc "Create the root Qset"
  task :root_qset => :environment do
    Qset.create( :name => 'Root' )
  end

  desc "Run all bootstrapping tasks"
  task :all => [:default_admin_user, :default_test_user, :root_qset]
end