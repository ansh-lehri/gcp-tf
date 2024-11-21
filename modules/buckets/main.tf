resource "google_storage_bucket" "frontend_bucket" {
  name     = var.bucket.name
  location = var.bucket.location

  dynamic cors {
    for_each = zipmap(
      [for idx,cor in var.bucket.cors : idx],
      var.bucket.cors
    )
    content {
      origin = cors.value.origin
      method = cors.value.method
    }
  }
  website {
    main_page_suffix = var.bucket.website.main_page_suffix
    not_found_page   = var.bucket.website.not_found_page
  }
}