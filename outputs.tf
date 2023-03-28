output "cribl_worker_instances" {
  value = "${aws_instance.worker.*.id}"
}

