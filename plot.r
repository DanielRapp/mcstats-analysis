require(ggplot2)
require(scales)
require(plyr)

# 2,300,000 pre-converted csv snooping records (100,000 from each hour, except hour 1)
mcr <- read.csv(file='csv/client/mc_random.csv', sep=',', head=TRUE)

# ~700,000 pre-converted csv random snooping records
# (only records with more than one instance of the same token)
mcrd <- read.csv(file='csv/client/duplicates/mc_random_duplicates.csv', sep=',', head=TRUE)

# Remove anomalous data
sub_mc = subset(mcr, fps<150 & fps>1)

### FPS distribution ###
min_fps = min(sub_mc$fps)
max_fps = max(sub_mc$fps)
break_seq = seq(min_fps, max_fps, by=5)
p <- ggplot(data=sub_mc, aes(x=fps)) +
     geom_histogram(binwidth=2) +
     ggtitle("fps distribution") +
     facet_grid(vsync_enabled ~ .) +
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

sample.df <- function(df, n) df[sample(nrow(df), n), , drop = FALSE]

# # # # # # # # SERVER # # # # # # # #

mcrs <- read.csv(file='csv/server/mc_rand_serv_dedicated.csv', sep=',', head=TRUE)
sub_mcrs <- subset( sample.df(mcrs, 100000), avg_tick_ms > 1 & avg_tick_ms < 100000 & players_seen > 0)

### Tick distribution ###
p <- ggplot(data=subset(sub_mcrs, avg_tick_ms<200 & avg_tick_ms>1 & players_seen>100),
        aes(x=avg_tick_ms)) +
  geom_histogram(bin=5) +
  ggtitle("Average tick ms distribution") +
  xlab("Average tick ms")
plot(p)
ggsave(plot=p, filename='img/avg_tick_ms_dist.png', width=10, height=10)

### Mod popularity ###
ssub_mcrs <- subset(sub_mcrs, avg_tick_ms>1 & players_seen>0)
sb <- ddply(ssub_mcrs, .(server_brand),
        function(x) data.frame( count=nrow(x), ratio=nrow(x)/nrow(ssub_mcrs), avg_usr_curr=mean(x$players_current), avg_usr_seen=mean(x$players_seen) ) )

p <- ggplot(data=sb, aes(x=reorder(server_brand, -ratio), y=ratio, fill=as.factor(round(avg_usr_curr)), color=avg_usr_seen)) +
  geom_bar(stat="identity", size=2) +
  ggtitle("Server mod popularity") +
  xlab("Mod") +
  ylab("Servers") +
  labs(fill="Average\nOnline\nUsers", color="Average\nUsers\nSeen") +
  scale_y_continuous(labels=percent)
plot(p)
ggsave(plot=p, filename='img/server_mod_pop.png')

### Minecraft version adoption a###
sb <- ddply(sub_mcrs, .(server_brand, version),
        function(x) data.frame( count=nrow(x), ratio=nrow(x)/nrow(sub_mcrs), mean_tick=mean(x$avg_tick_ms) ))

p <- ggplot(data=subset(sb, (server_brand=="vanilla" | server_brand=="craftbukkit") & mean_tick < 25),
        aes(x=version, y=count, fill=mean_tick)) +
  geom_bar(stat="identity") +
  facet_grid(. ~ server_brand) +
  ggtitle("Minecraft server version adoption") +
  xlab("Version") +
  ylab("Servers") +
  labs(fill="Average\ntick ms") +
  theme(axis.text.x = element_text(angle = 60, hjust = 1))
plot(p)
ggsave(plot=p, filename='img/java_version_dist_mod.png')

### Most memory efficient mod ###
sb <- ddply(subset(sub_mcrs, players_current>5), .(server_brand), function(x) data.frame(
        mem_per_player = mean((x$memory_free/x$memory_total)/x$players_current), count=nrow(x)
      ))

p <- ggplot(data=subset(sb, count>100), aes(x=reorder(server_brand, mem_per_player), y=mem_per_player)) +
  geom_bar(stat="identity") +
  ggtitle("Most memory efficient mod (lower is better)") +
  xlab("Mod") +
  ylab("% active RAM used by a given player") +
  labs(fill="Average total RAM") +
  scale_y_continuous(labels=percent)
plot(p)
ggsave(plot=p, filename='img/ram_per_user.png')

### Fastest server type ###
sb <- ddply(subset(sub_mcrs, players_current>10 & (server_brand == "craftbukkit" | server_brand=="fml") ),
      .(server_brand, gui_supported), function(x) data.frame(
        mem_per_player = mean((x$memory_free/x$memory_total)/x$players_current), count=nrow(x), mean_tick=mean(x$avg_tick_ms)
      ))

p <- ggplot(data=subset(sb, count>10), aes(x=reorder(gui_supported, mean_tick), y=mean_tick, fill=round(mem_per_player*10000)/100)) +
  geom_bar(stat="identity") +
  ggtitle("Fastest server type") +
  facet_grid(. ~ server_brand) +
  xlab("Type") +
  labs(fill="% active ram\nused by a\ngiven player") +
  ylab("Average tick ms")
plot(p)
ggsave(plot=p, filename='img/fastest_mod.png')

### Fastest server OS ###
sb <- ddply(subset(sub_mcrs, players_current>10),
      .(os_name), function(x) data.frame(
        mem_per_player = mean((x$memory_free/x$memory_total)/x$players_current), count=nrow(x), mean_tick=mean(x$avg_tick_ms)
      ))

p <- ggplot(data=subset(sb, count>10), aes(x=reorder(os_name, mean_tick), y=mean_tick, fill=round(mem_per_player*10000)/100)) +
  geom_bar(stat="identity") +
  ggtitle("Fastest server OS") +
  xlab("OS") +
  labs(fill="% active ram\nused by a\ngiven player") +
  ylab("Average tick ms") +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))
plot(p)
ggsave(plot=p, filename='img/fastest_os.png')

### Fastest Linux version ###
sb <- ddply(subset(sub_mcrs, players_current>10 & os_name=="Linux"),
      .(os_version), function(x) data.frame(
        mem_per_player = mean((x$memory_free/x$memory_total)/x$players_current), count=nrow(x), mean_tick=mean(x$avg_tick_ms)
      ))

p <- ggplot(data=subset(sb, count>100), aes(x=reorder(os_version, mean_tick), y=mean_tick, fill=round(mem_per_player*10000)/100)) +
  geom_bar(stat="identity") +
  ggtitle("Fastest Linux version") +
  xlab("Linux version") +
  labs(fill="% active ram\nused by a\ngiven player") +
  ylab("Average tick ms") +
  theme(axis.text.x = element_text(angle = 60, hjust = 1))
plot(p)
ggsave(plot=p, filename='img/fastest_linux_version.png')

