## Generating some predefined categories for JoinCategory:

category <- list(
  bos = c("bos taurus", "bos primigenius"),
  ovis = c("ovis aries", "ovis orientalis"),
  capra = c("capra hircus", "capra aegagrus"),
  sus = c("sus domesticus", "sus scrofa"),
  caprine = c("ovis aries", "ovis orientalis",
              "capra hircus", "capra aegagrus", "ovis/capra"),
  phal1 = c("first phalanx", "posterior first phalanx",
                      "anterior first phalanx"),
  phal2 = c("second phalanx", "posterior second phalanx",
                      "anterior second phalanx"),
  phal3 = c("third phalanx", "posterior third phalanx",
                      "anterior third phalanx"),
)

usethis::use_data(category, overwrite = TRUE)

