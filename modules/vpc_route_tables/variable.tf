variable "vpc_id" {}
variable "private_route_tables" {
  default = {
    shomotsu_development_private-1a = {
      Name = "shomotsu_development_rtb_private1_ap_northeast_1a"
    },
    shomotsu_development_private-1c = {
      Name = "shomotsu_development_rtb_private2_ap_northeast_1c"
    },
    shomotsu_development_private-1d = {
      Name = "shomotsu_development_rtb_private3_ap_northeast_1d"
    },
  }
}
variable "public_route_table_name" {}
variable "env" {}