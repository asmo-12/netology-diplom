data "tfe_outputs" "diplom" {
  organization = "asmo12-org"
  workspace    = "stage"
}
output "backet_id" {
  value = data.tfe_outputs.diplom.id
}
output "backet_org" {
  value = data.tfe_outputs.diplom.organization
}
# output "backet_values" {
#   value = data.tfe_outputs.diplom.values 
#   sensitive = true
# }
output "backet_workspace" {
  value = data.tfe_outputs.diplom.workspace
}
