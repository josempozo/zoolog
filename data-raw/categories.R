## Generating some predefined categories for JoinCategory:

category <- list(
  bos = c("bos taurus", "bos primigenius"),
  ovis = c("ovis aries", "ovis orientalis"),
  capra = c("capra hircus", "capra aegagrus"),
  sus = c("sus domesticus", "sus scrofa"),
  caprine = c("ovis aries", "ovis orientalis",
              "capra hircus", "capra aegagrus", "ovis/capra")
)

usethis::use_data(category, overwrite = TRUE)

