# CVWO assignment backend

A minimal implementation of the assignment, a forum that users can register and login, and perform basic CRUD operations for forum threads and comments.

The backend has been deployed using Render: [https://cvwo-backend-2voo.onrender.com](https://cvwo-backend-2voo.onrender.com)

Note: as the backend is only a API application, the link above does not show anything.

## Getting Started

### Running the app
1. [Fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo#forking-a-repository) this repo.
2. [Clone](https://docs.github.com/en/get-started/quickstart/fork-a-repo#cloning-your-forked-repository) **your** forked repo.
3. Open your terminal and navigate to the directory containing your cloned project.
4. Install dependencies for the project by entering this command:

```bash
bundle install
```

5. Migrate the database:
```
rails db:migrate
```

6. Run the app in development mode by entering this command:

```bash
rails server
```

7. The server will be hosted here: [http://localhost:3000](http://localhost:3000) to view it in the browser.

## Additional Notes
-   This project uses [Ruby on Rails](https://rubyonrails.org/).

## Acknowledgements

Part of the following tutorials were followed during the implementation of the backend:

1. [rails-api-jwt-authentication](https://medium.com/binar-academy/rails-api-jwt-authentication-a04503ea3248)
2. [How To Set Up a Ruby on Rails v7 Project with a React Frontend on Ubuntu 20.04](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-ruby-on-rails-v7-project-with-a-react-frontend-on-ubuntu-20-04)

