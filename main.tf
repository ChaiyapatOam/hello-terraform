resource "github_repository" "hello" {
  name        = "hello-github-by-terraform"
  description = "My Github Repository Create by Terraform"

  visibility         = "public"
  auto_init          = "true"
  has_issues         = true
  gitignore_template = "Terraform"
}

# resource "github_issue" "first_issue" {
#   repository = github_repository.hello.name
#   title      = "First Issue"
#   body       = "This is the first issue from terraform."
# }

resource "github_repository_environment" "repo_environment" {
  repository  = github_repository.hello.name
  environment = "dev"
}

resource "github_actions_environment_secret" "test_secret" {
  repository      = github_repository.hello.name
  environment     = github_repository_environment.repo_environment.environment
  secret_name     = "dev_secret_name"
  plaintext_value = "%s"
}

resource "github_actions_environment_variable" "example_variable" {
  repository    = github_repository.hello.name
  environment   = github_repository_environment.repo_environment.environment
  variable_name = "dev_secret_name"
  value         = "example_variable_value"
}

resource "github_actions_secret" "example_secret" {
  repository      = github_repository.hello.name
  secret_name     = "dev_secret"
  plaintext_value = "some secret repo"
}

resource "github_actions_secret" "example_en_secret" {
  repository      = github_repository.hello.name
  secret_name     = "dev_secret_en"
  encrypted_value = base64encode("some enccrypt secret")
}

data "github_repository" "example_data" {
  name = github_repository.hello.name
}

data "github_actions_secrets" "secret_data" {
  name = github_repository.hello.name
}

output "action_secret" {
  value = data.github_actions_secrets.secret_data
}

output "git_repo" {
  value = data.github_repository.example_data.full_name
}

terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {
  token = var.github_pk
}
