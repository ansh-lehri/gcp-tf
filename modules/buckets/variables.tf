variable "bucket" {
  type = object({
    name = string
    location = string
    cors = list(object({
      origin = list(string)
      method = list(string)
    }))
    website = object({
      main_page_suffix = string
      not_found_page = string
    })
  })
}