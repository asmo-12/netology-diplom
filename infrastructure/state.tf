terraform {
  cloud {
    organization = "asmo12-org"
    workspaces {
      name = "stage"
    }
  }
}