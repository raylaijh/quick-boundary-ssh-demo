data "template_file" "instructions" {
   template = "${file("output.tpl")}"
   vars={
    b_addr = var.boundary_addr
    b_auth_id = var.auth_method_id
    b_auth_user = var.auth_login_user
    b_target_id = boundary_target.ubuntu.id
}
}


output "rendered" {
   value = "${data.template_file.instructions.rendered}"
}