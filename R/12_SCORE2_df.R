#' SCORE2/OP risk score function for data frame;
#' SCORE2/OP = Systematic COronary Risk Evaluation /and Older Population
#'
#' @description
#' This function allows you to calculate the SCORE2 and OP score row wise
#' in a data frame with the required variables. It would then retrieve a data
#' frame with two extra columns including the calculations and their classifications
#'
#' @param data
#' A data frame with all the variables needed for calculation:
#'  Age, Gender, smoker, systolic.bp, diabetes, total.chol,
#' total.hdl
#' @param Risk.region a character value to set the desired risk region calculations. Categories should include
#' @param Age a numeric vector of age values, in years
#' @param Gender a binary character vector of Gender values. Categories should include only 'male' or 'female'.
#' @param smoker a binary numeric vector, 1 = yes and 0 = no
#' @param systolic.bp a numeric vector of systolic blood pressure continuous values
#' @param total.chol a numeric vector of total cholesterol values, in mmol/L
#' @param total.hdl a numeric vector of total high density lipoprotein total.hdl values, in mmol/L
#' @param classify set TRUE if wish to add a column with the scores' categories
#' @param diabetes a binary numeric vector, 1 = yes and 0 = no
#'
#' @keywords
#' SCORE2/OP  Age Gender smoker systolic.bp diabetes total.chol
#' total.hdl classify
#'
#' @return
#' data frame with two extra columns including the SCORE2/OP score calculations
#' and their classifications
#'
#'
#' @examples
#'
#' # Create a data frame or list with the necessary variables
#' # Set the number of rows
#' num_rows <- 100
#'
#' # Create a larger dataset with 100 rows
#' cohort_xx <- data.frame(
#'    typical_symptoms.num = as.numeric(sample(0:6, num_rows, replace = TRUE)),
#'   ecg.normal = as.numeric(sample(c(0, 1), num_rows, replace = TRUE)),
#'   abn.repolarisation = as.numeric(sample(c(0, 1), num_rows, replace = TRUE)),
#'   ecg.st.depression = as.numeric(sample(c(0, 1), num_rows, replace = TRUE)),
#'   Age = as.numeric(sample(40:85, num_rows, replace = TRUE)),
#'   diabetes = sample(c(1, 0), num_rows, replace = TRUE),
#'   smoker = sample(c(1, 0), num_rows, replace = TRUE),
#'   hypertension = sample(c(1, 0), num_rows, replace = TRUE),
#'   hyperlipidaemia = sample(c(1, 0), num_rows, replace = TRUE),
#'   family.history = sample(c(1, 0), num_rows, replace = TRUE),
#'   atherosclerotic.disease = sample(c(1, 0), num_rows, replace = TRUE),
#'   presentation_hstni = as.numeric(sample(10:100, num_rows, replace = TRUE)),
#'   Gender = sample(c("male", "female"), num_rows, replace = TRUE),
#'   sweating = as.numeric(sample(c(0, 1), num_rows, replace = TRUE)),
#'   pain.radiation = as.numeric(sample(c(0, 1), num_rows, replace = TRUE)),
#'   pleuritic = as.numeric(sample(c(0, 1), num_rows, replace = TRUE)),
#'   palpation = as.numeric(sample(c(0, 1), num_rows, replace = TRUE)),
#'   ecg.twi = as.numeric(sample(c(0, 1), num_rows, replace = TRUE)),
#'   second_hstni = as.numeric(sample(1:200, num_rows, replace = TRUE)),
#'   killip.class = as.numeric(sample(1:4, num_rows, replace = TRUE)),
#'   systolic.bp = as.numeric(sample(90:180, num_rows, replace = TRUE)),
#'   heart.rate = as.numeric(sample(0:300, num_rows, replace = TRUE)),
#'   creat = as.numeric(sample(0:4, num_rows, replace = TRUE)),
#'   cardiac.arrest = as.numeric(sample(c(0, 1), num_rows, replace = TRUE)),
#'   previous.pci = as.numeric(sample(c(0, 1), num_rows, replace = TRUE)),
#'   previous.cabg = as.numeric(sample(c(0, 1), num_rows, replace = TRUE)),
#'   aspirin = as.numeric(sample(c(0, 1), num_rows, replace = TRUE)),
#'   number.of.episodes.24h = as.numeric(sample(0:20, num_rows, replace = TRUE)),
#'   total.chol = as.numeric(round(runif(num_rows, 3.9, 7.2), 1)),
#'   total.hdl = as.numeric(round(runif(num_rows, .8, 2.1), 1)),
#'   Ethnicity = sample(c("white", "black", "asian", "other"), num_rows, replace = TRUE)
#' )
#'
#' # Call the function with the cohort_xx
#' result <- SCORE2_scores(data = cohort_xx, Risk.region = "Low", classify = TRUE)
#'
#' # Print the results
#' summary(result$SCORE2_score)
#' summary(result$SCORE2_strat)
#'
#' @importFrom dplyr mutate
#' @importFrom dplyr rename
#' @importFrom dplyr %>%
#' @importFrom dplyr rowwise
#'
#' @export



SCORE2_scores <- function(data, Risk.region, Age = Age, Gender = Gender, smoker = smoker, systolic.bp = systolic.bp, diabetes = diabetes, total.chol = total.chol, total.hdl = total.hdl, classify) {

data <- data %>% rename(Age = Age, Gender = Gender, smoker = smoker, systolic.bp = systolic.bp, diabetes = diabetes, total.chol = total.chol, total.hdl = total.hdl)

  if (classify == TRUE) {
    results <- data  %>% rowwise() %>% mutate(
      SCORE2_score = SCORE2(
        Risk.region = Risk.region,
        Age,
        Gender,
        smoker,
        systolic.bp,
        diabetes,
        total.chol,
        total.hdl,
        classify = FALSE
      ),
      SCORE2_strat = SCORE2(
        Risk.region = Risk.region,
        Age,
        Gender,
        smoker,
        systolic.bp,
        diabetes,
        total.chol,
        total.hdl,
        classify = classify
      ) %>% as.factor() %>% ordered(
        levels = c("Very low risk", "Low risk", "Moderate risk", "High risk")
      )
    )

  }


  else{
    results <- data  %>% rowwise() %>% mutate(
      SCORE2_score = SCORE2(
        Risk.region = Risk.region,
        Age,
        Gender,
        smoker,
        systolic.bp,
        diabetes,
        total.chol,
        total.hdl,
        classify = classify
      )
    )
  }
  return(results)
}
