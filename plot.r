require(ggplot2)
require(scales)
require(plyr)

# 100,000 pre-converted csv snooping records (hour 0)
# mc1e5 <- read.csv(file='csv/mc1e5.csv', sep=',', head=TRUE)

# 1,000,000 pre-converted csv snooping records (hour 0)
#mc1e6 <- read.csv(file='csv/mc1e6.csv', sep=',', head=TRUE)

# 2,000,000 pre-converted csv snooping records (hour 0)
#mc2e6 <- read.csv(file='csv/mc2e6.csv', sep=',', head=TRUE)

# 3,000,000 pre-converted csv snooping records (hour 0)
#mc3e6 <- read.csv(file='csv/mc3e6.csv', sep=',', head=TRUE)

# ~5,000,000 pre-converted csv snooping records (hour 0, 2 and 3)
#mc5e6 <- read.csv(file='csv/client.snoopdata.csv', sep=',', head=TRUE)

# 2,300,000 pre-converted csv snooping records (100,000 from each hour, except hour 1)
mcr <- read.csv(file='csv/mc_random.csv', sep=',', head=TRUE)

# ~700,000 pre-converted csv random snooping records
# (only records with more than one instance of the same token)
mcrd <- read.csv(file='csv_duplicates/mc_random_duplicates.csv', sep=',', head=TRUE)

# Remove anomalous data
sub_mc = subset(mcr, fps<150 & fps>1)

### FPS distribution ###
min_fps = min(sub_mc$fps)
max_fps = max(sub_mc$fps)
break_seq = seq(min_fps, max_fps, by=5)
p <- ggplot(data=sub_mc, aes(x=fps)) +
     geom_histogram(binwidth=2) +
     ggtitle("fps distribution") +
     scale_x_continuous(breaks=break_seq) +
     xlab("1 < fps < 150") +
     ylab("fps frequency")
plot(p)
ggsave(plot=p, filename='img/fps_dist.png', width=10, height=5)

### FPS, setting correlation  ###
gl_columns <- sub_mc[grep("gl_caps", names(sub_mc))]
gl_columns <- sapply(gl_columns, as.integer)
cors <- as.data.frame(cor(sub_mc$fps, gl_columns, method="pearson"))

p <- ggplot(data=cors, aes(x=names(cors), y=laply(cors, function(x) x[1]))) +
     geom_bar(stat="identity") +
     ggtitle("What setting affect the fps most?") +
     xlab("Setting") +
     ylab("(Pearson) correlation to FPS") +
     ylim(0,1) +
     theme(axis.text.x = element_text(angle = 60, hjust = 1))
plot(p)
ggsave(plot=p, filename='img/fps_corr.png', width=10, height=5)

### Texturepack popularity ###
rows <- length(sub_mc$texpack_name)
tn <- ddply(sub_mc, .(texpack_name), function(x) nrow(x)/rows)

p <- ggplot(data=subset(tn, V1>0.001 & V1<0.8), aes(x=reorder(texpack_name, -V1), y=V1)) +
     geom_bar(stat="identity") +
     ggtitle("Most popular texturepacks (default not included)") +
     xlab("Texturepack") +
     ylab("Users") +
     scale_y_continuous(labels=percent) +
     theme(axis.text.x = element_text(angle = 40, hjust = 1))
plot(p)
ggsave(plot=p, filename='img/texpack.png', width=10, height=5)

### Java version popularity ###
rows <- length(sub_mc$java_version)
jv <- ddply(sub_mc, .(java_version), function(x) nrow(x)/rows)

p <- ggplot(data=subset(jv, V1>0.001), aes(x=reorder(java_version, -V1), y=V1)) +
# Uncomment for non-sorted version
#p <- ggplot(data=subset(jv, V1>0.001), aes(x=java_version, y=V1)) +
     geom_bar(stat="identity") +
     ggtitle("Distribution of Java versions") +
     xlab("Java version") +
     ylab("Users") +
     scale_y_continuous(labels=percent) +
     theme(axis.text.x = element_text(angle = 40, hjust = 1))
plot(p)
ggsave(plot=p, filename='img/java_by_popularity.png', width=10, height=5)

### OpenGL_vendor popularity ###
rows <- length(sub_mc$opengl_vendor)
ov <- ddply(sub_mc, .(opengl_vendor), function(x) nrow(x)/rows)

p <- ggplot(data=subset(ov, V1>0.001), aes(x=reorder(opengl_vendor, -V1), y=V1)) +
     geom_bar(stat="identity") +
     ggtitle("OpenGL vendor popularity") +
     xlab("OpenGL vendor") +
     ylab("Users") +
     scale_y_continuous(labels=percent) +
     theme(axis.text.x = element_text(angle = 40, hjust = 1))
plot(p)
ggsave(plot=p, filename='img/opengl_vendor.png', width=10, height=5)

### Client_brand popularity ###
rows <- length(mc6$client_brand)
cb <- ddply(mc6, .(client_brand), function(x) nrow(x)/rows)

p <- ggplot(data=subset(cb, V1>0.1), aes(x=factor(1), y=V1, fill=client_brand)) +
     geom_bar(stat="identity", position="fill", width = 1) +
     ggtitle("Client brand popularity") +
     coord_polar(theta = "y") +
     xlab("") +
     ylab("Users")
plot(p)
ggsave(plot=p, filename='img/client_brand.png', width=5, height=5)

### Number of plays in applet vs non-applet ###
applet_plays <- ddply(mcrd, .(applet),
  function(x) data.frame(mean_time_played=15*nrow(mcrd)/nrow(x), popularity=nrow(x)/nrow(mcrd)),
  .progress="text")

p <- ggplot(data=applet_plays, aes(x=as.factor(applet), y=mean_time_played*15, fill=as.factor(round(popularity*100)))) +
  geom_bar(stat="identity", position="dodge") +
  ggtitle("Minutes played in applet vs non-applet") +
  xlab("Applet") +
  ylab("Average minutes") +
  labs(fill="Popularity %")
plot(p)
ggsave(plot=p, filename='img/applet_minutes.png', width=5, height=5)

### Number of plays in windowed vs fullscreen ###
display_type_plays <- ddply(mcrd, .(display_type),
  function(x) data.frame(mean_time_played=15*nrow(mcrd)/nrow(x), popularity=nrow(x)/nrow(mcrd)),
  .progress="text")

p <- ggplot(data=display_type_plays, aes(x=factor(display_type), y=mean_time_played*15, fill=as.factor(round(popularity*100)))) +
  geom_bar(stat="identity", position="dodge") +
  ggtitle("Minutes played in windowed vs fullscreen") +
  xlab("Display Type") +
  ylab("Average minutes") +
  scale_y_continuous(breaks=seq(from=0, to=max(display_type_plays$mean_time_played*15), by=500)) +
  labs(fill="Popularity %")
plot(p)
ggsave(plot=p, filename='img/display_type_minutes.png', width=5, height=5)

