/*
Defines the units that can be used for watch accuracy tracking
 */
enum RateUnit {
  day,    // seconds per day (s/d)
  month,  // seconds per month (s/m) - Uses 30.4375 average days/month
  year    // seconds per year (s/y) - Uses 365.25 average days/year
}