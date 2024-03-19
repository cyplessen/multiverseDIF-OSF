#' PROMIS Physical Function Ceiling Items from the US, Germany, Argentina
#'
#' A dataset containing the item responses for 35 ceiling items and sociodemographic data
#' 3601 individuals. The variables are as follows:
#' @name data_complete
#' @usage data(data_complete)
#' @docType data
#' 
#' @format A data frame with 3601 rows and 145 variables:
#' \describe{
#'   \item{country}{ Country of data collection (usa--ger--arg)}
#'   \item{age}{Age of Participants (18--88)}
#'   \item{gender}{Gender of participants (1 = male, 2 = female, 3 = diverse)}
#'   \item{respondent_id}{ID of participants (unique number)}
#'   \item{edu_harmonized}{Harmonized education level of participants (Basic, Secondary, Vocational/Some College, Higher)}
#'   \item{employment}{Employment status of participants:(1 = Full-time employed, 2 = Part-time employed, 3 = Self-employed,4 = Student, 5 = Retired/Pensioner/Early retiree, 6 = Unemployed/Not working, 9 = Other)}
#'   \item{PFM1}{PROMIS ceiling item PFM1 "Are you able to dig a 2-foot (1/2 m) deep hole in the dirt with a shovel?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM2}{PROMIS ceiling item PFM2 "Are you able to lift a heavy painting or picture to hang on your wall above eye-level?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM3}{PROMIS ceiling item PFM3 "Are you able to paint the walls of a room with a brush or roller for 2 hours without stopping to rest?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM4}{PROMIS ceiling item PFM4 "Are you able to row a boat for 30 minutes without stopping to rest?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM6}{PROMIS ceiling item PFM6 "Are you able to hand wash and wax a car for 2 hours without stopping to rest?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM7}{PROMIS ceiling item PFM7 "Are you able to complete 5 push-ups without stopping?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM9}{PROMIS ceiling item PFM9 "Are you able to rake leaves or sweep for an hour without stopping to rest?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM10}{PROMIS ceiling item PFM10 "Are you able to do a pull-up?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM12}{PROMIS ceiling item PFM12 "Are you able to lift a heavy object (20 lbs/10 kg) above your head?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM15}{PROMIS ceiling item PFM15 "Are you able to hit the backboard with a basketball from the free-throw line (13 ft/4 m)?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM16}{PROMIS ceiling item PFM16 "Are you able to pass a 20-pound (10 kg) turkey or ham to other people at the table?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM17}{PROMIS ceiling item PFM17 "Are you able to remove a heavy suitcase (50 lbs/25 kg) from an overhead bin on an airplane or bus?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM18}{PROMIS ceiling item PFM18 "Are you able to continuously swing a baseball bat or tennis racket back and forth for 5 minutes?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM19}{PROMIS ceiling item PFM19 "Are you able to complete 10 sit-ups without stopping?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM21}{PROMIS ceiling item PFM21 "Are you able to climb the stairs of a 10-story building without stopping?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM23}{PROMIS ceiling item PFM23 "Are you able to walk briskly for 20 minutes without stopping to rest?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM25}{PROMIS ceiling item PFM25 "Are you able to come to a complete stop while running?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM26}{PROMIS ceiling item PFM26 "Are you able to make sharp turns while running fast?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM27}{PROMIS ceiling item PFM27 "Are you able to jump rope for 10 minutes without stopping?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM28}{PROMIS ceiling item PFM28 "Are you able to jump over an object that is 1 foot (30 cm) tall?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM29}{PROMIS ceiling item PFM29 "Are you able to jump over a puddle that is 3 feet (1 m) wide?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM32}{PROMIS ceiling item PFM32 "Are you able to jump 2 feet (60 cm) high?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM33}{PROMIS ceiling item PFM33 "Are you able to walk across a balance beam?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM34}{PROMIS ceiling item PFM34 "Are you able to stand on one foot with your eyes closed for 30 seconds?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM35}{PROMIS ceiling item PFM35 "Are you able to walk in a straight line putting one foot in front of the other (heel to toe) for 5 yards (5 m)?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM36}{PROMIS ceiling item PFM36 "Are you able to put your hands flat on the floor with both feet flat on the ground?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM37}{PROMIS ceiling item PFM37 "Are you able to carry a large baby (15 lbs/7 kg) out of the house to a car or taxi?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM38}{PROMIS ceiling item PFM38 "Are you able to lift and load one 50-pound (25 kg) bag of sand into a car?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM40}{PROMIS ceiling item PFM40 "Are you able to climb a 6-foot (2 m) ladder?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM43}{PROMIS ceiling item PFM43 "Are you able to push an empty refrigerator forward 1 yard (1 m)?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM44}{PROMIS ceiling item PFM44 "Are you able to carry a 50 lb (25 kg) bag of sand 25 yards (25 m)?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM46}{PROMIS ceiling item PFM46 "Are you able to pull a sled or a wagon with two children (total 100 lbs/50 kg) for 100 yards (100 m)?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM49}{PROMIS ceiling item PFM49 "Are you able to stand up from a push-up position five times quickly?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM51}{PROMIS ceiling item PFM51 "Are you able to swim laps for 30 minutes at a moderate pace?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#'   \item{PFM53}{PROMIS ceiling item PFM53 "Are you able to dance energetically for an hour?" Scored from 1 (Unable to do) to 5 (Without any difficulty)}
#' }
#' @export