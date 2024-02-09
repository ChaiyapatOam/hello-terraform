import {
  to = github_repository.ex
  id = "hello-github-by-terraform"
}

resource "github_repository" "ex" {
  name = "hello-github-by-terraform"
}
