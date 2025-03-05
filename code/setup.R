

# Reading in data
# tree maps
pbb_tables_for_tm <- readRDS(here::here("data/separated/pbb_tables_for_tm.rds"))
pbb_tables_for_tm_names <- names(pbb_tables_for_tm)
for (name in pbb_tables_for_tm_names) {
  assign(paste0("tm_", name), pbb_tables_for_tm[[name]])
}

# reactable tables
pbb_tables_for_rt <- readRDS(here::here("data/separated/pbb_tables_for_rt.rds"))
pbb_tables_for_rt_names <- names(pbb_tables_for_rt)
for (name in pbb_tables_for_rt_names) {
  assign(paste0("rt_", name), pbb_tables_for_rt[[name]])
}

# bar plots
pbb_tables_for_bp <- readRDS(here::here("data/separated/pbb_tables_for_bp.rds"))
pbb_tables_for_bp_names <- names(pbb_tables_for_bp)
for (name in pbb_tables_for_bp_names) {
  assign(paste0("bp_", name), pbb_tables_for_bp[[name]])
}

### To be added once word clouds are up in order to maintain function of wordclouds

# word clouds 
pbb_tables_for_wc <- readRDS(here::here("data/separated/pbb_tables_for_wc.rds"))
pbb_tables_for_wc_names <- names(pbb_tables_for_wc)
for (name in pbb_tables_for_wc_names) {
  assign(name, pbb_tables_for_wc[[name]])
}

# Sentence Tables Reasons
pbb_tables_for_reasons <- readRDS(here::here("data/separated/sent_tables_for_reasons.rds"))
pbb_tables_for_reasons_names <- names(pbb_tables_for_reasons)
for (name in pbb_tables_for_reasons_names) {
  assign(name, pbb_tables_for_reasons[[name]])
}


# bar_plot_list <- list.files(path = "code/www/bars", pattern = "ebar_.*\\.png", full.names = TRUE)
# bar_plot_info <- lapply(strsplit(basename(bar_plot_list), "_|\\.png"), function(x) {
#  list(building_name = x[2], belong_status = x[3], group = x[4])
#   })
# bar_plot_df <- do.call(rbind, lapply(bar_plot_info, as.data.frame))
# colnames(bar_plot_df) <- c("building_name", "belong_status", "group")
# building_names <- unique(bar_plot_df$building_name)
# belong_statuses <- unique(bar_plot_df$belong_status)
# groups <- unique(bar_plot_df$group)



source("code/helpers.R")

available_maps <- c(
  "map_emu_b_gr_ay2122.png",
  "map_emu_db_us_ug_ay2122_c2122.png",
  "map_emu_db_us_ug_ay2122_c2021.png",
  "map_emu_db_us_ug_ay2122_c1920.png",
  "map_emu_db_us_ug_ay2122_c1819.png",
  "map_emu_db_us_ug_ay2122.png",
  "map_emu_db_us_ug_ay1920_c1920.png",
  "map_emu_db_us_ug_ay1920_c1819.png",
  "map_emu_db_us_ug_ay1920_c1718.png",
  "map_emu_db_us_ug_ay1920_c1617.png",
  "map_emu_db_us_ug_ay1920.png",
  "map_emu_db_us_ug_ay1819_c1819.png",
  "map_emu_db_us_ug_ay1819_c1718.png",
  "map_emu_db_us_ug_ay1819_c1617.png",
  "map_emu_db_us_ug_ay1819_c1516.png",
  "map_emu_db_us_ug_ay1819.png",
  "map_emu_db_us_ug_ay1718.png",
  "map_emu_db_i_ug_ay1920.png",
  "map_emu_db_i_ay2122.png",
  "map_emu_db_gr_ay2122.png",
  "map_emu_b_us_ug_ay2122_c2122.png",
  "map_emu_b_us_ug_ay2122_c2021.png",
  "map_emu_b_us_ug_ay2122_c1920.png",
  "map_emu_b_us_ug_ay2122_c1819.png",
  "map_emu_b_us_ug_ay2122.png",
  "map_emu_b_us_ug_ay1920_c1920.png",
  "map_emu_b_us_ug_ay1920_c1819.png",
  "map_emu_b_us_ug_ay1920_c1718.png",
  "map_emu_b_us_ug_ay1920_c1617.png",
  "map_emu_b_us_ug_ay1920.png",
  "map_emu_b_us_ug_ay1819_c1819.png",
  "map_emu_b_us_ug_ay1819_c1718.png",
  "map_emu_b_us_ug_ay1819_c1617.png",
  "map_emu_b_us_ug_ay1819_c1516.png",
  "map_emu_b_us_ug_ay1819.png",
  "map_emu_b_us_ug_ay1718.png",
  "map_emu_b_i_ug_ay1920.png",
  "map_emu_b_i_ay2122.png",
  # Add campus maps
  "map_cam_db_us_ug_ay2122_c2122.png",
  "map_cam_db_us_ug_ay2122_c2021.png",
  "map_cam_db_us_ug_ay2122_c1920.png",
  "map_cam_db_us_ug_ay2122_c1819.png",
  "map_cam_db_us_ug_ay2122.png",
  "map_cam_db_us_ug_ay1920_c1920.png",
  "map_cam_db_us_ug_ay1920_c1819.png",
  "map_cam_db_us_ug_ay1920_c1718.png",
  "map_cam_db_us_ug_ay1920_c1617.png",
  "map_cam_db_us_ug_ay1920.png",
  "map_cam_db_us_ug_ay1819_c1819.png",
  "map_cam_db_us_ug_ay1819_c1718.png",
  "map_cam_db_us_ug_ay1819_c1617.png",
  "map_cam_db_us_ug_ay1819_c1516.png",
  "map_cam_db_us_ug_ay1819.png",
  "map_cam_db_us_ug_ay1718.png",
  "map_cam_db_us_ug_ay1617.png",
  "map_cam_db_i_ug_ay1920.png",
  "map_cam_db_i_ay2122.png",
  "map_cam_db_gr_ay2122.png",
  "map_cam_b_us_ug_ay2122_c2122.png",
  "map_cam_b_us_ug_ay2122_c2021.png",
  "map_cam_b_us_ug_ay2122_c1920.png",
  "map_cam_b_us_ug_ay2122_c1819.png",
  "map_cam_b_us_ug_ay2122.png",
  "map_cam_b_us_ug_ay1920_c1920.png",
  "map_cam_b_us_ug_ay1920_c1819.png",
  "map_cam_b_us_ug_ay1920_c1718.png",
  "map_cam_b_us_ug_ay1920_c1617.png",
  "map_cam_b_us_ug_ay1920.png",
  "map_cam_b_us_ug_ay1819_c1819.png",
  "map_cam_b_us_ug_ay1819_c1718.png",
  "map_cam_b_us_ug_ay1819_c1617.png",
  "map_cam_b_us_ug_ay1819_c1516.png",
  "map_cam_b_us_ug_ay1819.png",
  "map_cam_b_us_ug_ay1718.png",
  "map_cam_b_us_ug_ay1617.png",
  "map_cam_b_i_ug_ay1920.png",
  "map_cam_b_i_ay2122.png",
  "map_cam_b_gr_ay2122.png"
)