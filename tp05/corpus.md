## Un premier exemple de règle d'association
Les informations retournées par l'algorithme sont :
* le nombre de cycles effectués ;
* les tailles des itemsets ;
* les meilleures règles d'association trouvées.

## Modification des paramètres
### Question 1

### Question 2
Règle choisie : temperature=cool 4 ==> humidity=normal 4
\[
Confiance(temperature = cool \Rightarrow humidity = normal) = \frac{P(temperature = cool \land humidity = normal)}{P(temperature = cool)} = \frac{\frac{4}{10}}{\frac{4}{10}} = 1.0
Amélioration(temperature = cool \Rightarrow humidity = normal) = \frac{P(temperature cool | humidity = normal)}{P(temperature = cool) \times P(humidity = cool)} = \frac{P(temperature cool \land humidity = normal)}{P(temperature = cool) \times P(humidity = cool)}
\]
