# Generated with RailsBricks
# Initial seed file to use with Devise User Model

# Temporary admin account
u = User.new(
    username: "admin",
    email: "admin@example.com",
    password: "password",
    password_confirmation: "password",
    admin: true
)
u.skip_confirmation!
u.save!

u = User.new(
    username: "user",
    email: "user@example.com",
    password: "password",
    password_confirmation: "password",
    admin: false
)
u.skip_confirmation!
u.save!
