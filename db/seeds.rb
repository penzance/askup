# Create the root Qset
Qset.create( name: 'Root' )

# Add the default admin user
User.create(
  first_name: 'Ask',
  last_name: 'Up',
  email: 'auadmin@example.com',
  password: 'password',
  role: 'admin',
  org_id: 1
)

# Add the default test user
User.create(
  first_name: 'Inquisitive',
  last_name: 'Queryhands',
  email: 'testuser@example.com',
  password: 'password',
  role: 'contributor',
  org_id: 1
)
