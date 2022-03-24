
mob_2020 <- read.table("mobility_2020.csv", header=TRUE, sep=",")
mob_2020<- mob_2020[1:321,9:15]

mob_2021 <- read.table("mobility_2021.csv", header=TRUE, sep=",")
mob_2021<- mob_2021[1:365,9:15]

mob_2022 <- read.table("mobility_2022.csv", header=TRUE, sep=",")
mob_2022 <- mob_2022[1:72, 9:15]


mob_total <- rbind(mob_2020, mob_2021, mob_2022)

mob_total$rr <- mob_total$retail_and_recreation_percent_change_from_baseline

mob_total$gp <- mob_total$grocery_and_pharmacy_percent_change_from_baseline

mob_total$p <- mob_total$parks_percent_change_from_baseline

mob_total$ts<- mob_total$transit_stations_percent_change_from_baseline

mob_total$w <- mob_total$workplaces_percent_change_from_baseline

mob_total$r <- mob_total$residential_percent_change_from_baseline

write.table(mob_total[,c("date","rr", "gp", "p", "ts", "w", "r")], "mob_red.csv", sep=",")