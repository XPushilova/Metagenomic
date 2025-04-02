# Metagenomika
# Author: Xeniya Pushilova
# R version 4.2.1



# Načtení knihoven
library(ggplot2)
library(reshape2)


# Definujeme funkci pro načtení dat a spočítání četností COG kategorií
count_cog_frequencies <- function(file_path) {
  data <- read.csv(file_path)  # Načtení CSV souboru
  freq_table <- table(data$X.5[3:(length(data$X.5)-3)])  # Počítání četností
  return(freq_table)
}

# Použití funkce pro oba soubory
pos_freq <- count_cog_frequencies('Pos_EggnogMapper_Output.csv')
neg_freq <- count_cog_frequencies('Neg_EggnogMapper_Output.csv')

# TASK 2
# plot graph with sum of each COG category in both data frames
par(mfrow = c(1,2))
barplot(pos_freq, main = "Gram-pozitivní bakterie",xlab = "COG kategorie", ylab = "Počet výskytů", ylim = c(0,2000), col = "steelblue")
barplot(neg_freq, main = "Gram-negativní bakterie",xlab = "COG kategorie", ylab = "Počet výskytů", ylim = c(0, 500), col = "steelblue")

# TASK 3
# preferred genes for both data frames
pos_pref_gene = c(pos_eggnog$X.7[3:(length(pos_eggnog$X.7)-3)])
neg_pref_gene = c(neg_eggnog$X.7[3:(length(pos_eggnog$X.7)-3)])

# intersection of preferred genes in gram positive and negative bacteries
intersect_pref_gene = intersect(pos_pref_gene, neg_pref_gene)  #output: "dnaK" "tuf"  "rplB" "rplK" "rpsL" "rpsM" "rplN" "rpsS"




# Výběr prvních 30 sekvencí
pos_seq_30 <- pos_eggnog[3:32, ]
neg_seq_30 <- neg_eggnog[3:32, ]

# Vytvoření datového rámce pro gram-pozitivní bakterie
pos_heatmap_matrix = matrix(0, nrow = 30, ncol = length(intersect_pref_gene))

for (i in 1:30) {
  for (j in 1:length(intersect_pref_gene)) {
    if (intersect_pref_gene[j] == pos_seq_30$X.7[i]) {
      pos_heatmap_matrix[i, j] <- 1
    }
  }
}

# Převedení matice na data.frame pro ggplot2
pos_heatmap_df <- as.data.frame(pos_heatmap_matrix)
colnames(pos_heatmap_df) <- intersect_pref_gene
pos_heatmap_df$Sequence <- 1:30

# Převod na long formát pro ggplot
pos_heatmap_df_melted <- melt(pos_heatmap_df, id.vars = "Sequence", variable.name = "Gene", value.name = "Presence")

# Vykreslení heatmapy
ggplot(pos_heatmap_df_melted, aes(x = Gene, y = Sequence, fill = factor(Presence))) +
  geom_tile() +
  scale_fill_manual(values = c("gray90", "steelblue"),  name = "") +
  labs(title = "Heatmapa gram-pozitivních bakterií", x = "Preferred_name gene", y = "Pořadí sekvence") +
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5))



# Vytvoření datového rámce pro gram-pozitivní bakterie
neg_heatmap_matrix = matrix(0, nrow = 30, ncol = length(intersect_pref_gene))

# Iterace přes všechny sekvence a geny, a naplňování matice podle přítomnosti genů v sekvencích
for (i in 1:30) {
  for (j in 1:length(intersect_pref_gene)) {
    if (intersect_pref_gene[j] == neg_seq_30$X.7[i]) {
      neg_heatmap_matrix[i, j] <- 1
    }
  }
}

# Převedení matice na data.frame pro ggplot2
neg_heatmap_df <- as.data.frame(neg_heatmap_matrix)
colnames(neg_heatmap_df) <- intersect_pref_gene
neg_heatmap_df$Sequence <- 1:30

# Převod na long formát pro ggplot
neg_heatmap_df_melted <- melt(neg_heatmap_df, id.vars = "Sequence", variable.name = "Gene", value.name = "Presence")

# Vykreslení heatmapy
ggplot(neg_heatmap_df_melted, aes(x = Gene, y = Sequence, fill = factor(Presence))) +
  geom_tile() +
  scale_fill_manual(values = c("gray90", "red"),  name = "") +
  labs(title = "Heatmapa gram-negativních bakterií", x = "Preferred_name gene", y = "Pořadí sekvence") +
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5))
