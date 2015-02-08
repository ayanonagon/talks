# Natural Language Processing
## with /swɪft/

Ayaka Nonaka
@ayanonagon

---

# SPAM  spam  sp@M  $PAM  spam  sp@m  SP4M  $p@m  sp@M SPAM  spam  sp@M  $PAM  spam  sp@m  SP4M  $p@m  sp@M

![](spam.jpg)

---

# Spam
## or
# Ham?

---

# Naive Bayes Classifier

---

# Bayes’ theorem

$$
P(A|B) = \frac{P(A)P(B|A)}{P(B)}
$$

---

$$
P(A \cap B) = P(A) P(B|A)
$$

---

$$
P(A \cap B) = P(A) P(B|A)
$$

Probability of :spades: & :a: ?

---

$$
P(A \cap B) = P(A) P(B|A)
$$

Probability of :spades: & :a: ?

`=`

Probability of :spades:
×
Probability of :a: given :spades:

---

$$
P(A \cap B) = P(A) P(B|A)
$$

Probability of :spades: & :a: ?

`=`

Probability of :spades: = 1/4
×
Probability of :a: given :spades:

---

$$
P(A \cap B) = P(A) P(B|A)
$$

Probability of :spades: & :a: ?

`=`

Probability of :spades: = 1/4
×
Probability of :a: given :spades: = 1/13

---

$$
P(A \cap B) = P(A) P(B|A)
$$

Probability of :spades: & :a: ?

`=`

Probability of :spades: = 1/4
×
Probability of :a: given :spades: = 1/13

`=`

1/52

---

$$
P(A \cap B) = P(A) P(B|A)
$$

---

$$
P(A \cap B) = P(A) P(B|A)
$$

$$
P(A \cap B) = P(B) P(A|B)
$$

---

$$
P(A \cap B) = P(A) P(B|A)
$$

$$
P(A \cap B) = P(B) P(A|B)
$$

$$
P(A) P(B|A) = P(B) P(A|B)
$$

---

$$
P(A \cap B) = P(B) P(A|B)
$$

$$
P(A \cap B) = P(A) P(B|A)
$$

$$
P(B) P(A|B) = P(A) P(B|A)
$$

$$
P(A|B) = \frac{P(A) P(B|A)}{P(B)}
$$

---

* 30 emails of a total of 50 are spam
* 20 out of the total 50 contain the word SODIUM
* 15 of the emails that contain the word SODIUM are spam

---

* 30 emails of a total of 50 are spam
* 20 out of the total 50 contain the word SODIUM
* 15 of the emails that contain the word SODIUM are spam

What’s the probability that an email is spam given that it contains the word SODIUM?

---

* 30 emails of a total of 50 are spam
* 20 out of the total 50 contain the word SODIUM
* 15 of the emails that contain the word SODIUM are spam

What’s the probability that an email is spam given that it contains the word SODIUM?

$$
P(spam|SODIUM) = \frac{P(spam) P(SODIUM|spam)}{P(SODIUM)}
$$

$$
= \frac{\frac{30}{50} \frac{15}{30}}{\frac{20}{50}} = 0.75
$$

---

* 30 emails of a total of 50 are spam
* 20 out of the total 50 contain the word SODIUM
* 15 of the emails that contain the word SODIUM are spam

---

* 30 emails of a total of 50 are spam
* 20 out of the total 50 contain the word SODIUM
* 15 of the emails that contain the word SODIUM are spam
* 15 out of the total 50 contain the word CHOLESTEROL
* 10 of the emails that contain the word CHOLESTEROL are spam

---

$$
P(spam|S \cap C)
$$

---

$$
P(spam|S \cap C)
$$

$$
= \frac{P(spam)P(S \cap C|spam)}{P(S \cap C)}
$$

---

$$
P(spam|S \cap C)
$$

$$
= \frac{P(spam)P(S \cap C|spam)}{P(S \cap C)}
$$

$$
= \frac{P(spam)P(S \cap C|spam)}{P(S)P(C|S)}
$$

---

$$
P(spam|S \cap C)
$$

$$
= \frac{P(spam)P(S \cap C|spam)}{P(S \cap C)}
$$

$$
= \frac{P(spam)P(S \cap C|spam)}{P(S)P(C|S)}
$$

$$
= \frac{P(spam \cap S \cap C)}{P(S)P(C|S)}
$$

---

$$
P(spam|S \cap C)
$$

$$
= \frac{P(spam)P(S \cap C|spam)}{P(S \cap C)}
$$

$$
= \frac{P(spam)P(S \cap C|spam)}{P(S)P(C|S)}
$$

$$
= \frac{P(spam \cap S \cap C)}{P(S)P(C|S)}
$$

$$
= \frac{P(spam)P(S|spam)P(C|spam \cap S)}{P(S)P(C|S)}
$$

---

Throw in another word, $$Z$$.

$$
\frac{P(spam)P(S|spam)P(C|spam \cap S)P(Z|spam \cap S \cap C)}{P(S)P(C|S)P(Z|S \cap C)}
$$

---

* 30 emails of a total of 50 are spam
* 20 out of the total 50 contain the word SODIUM
* 15 of the emails that contain the word SODIUM are spam
* 15 out of the total 50 contain the word CHOLESTEROL
* 10 of the emails that contain the word CHOLESTEROL are spam

$$
= \frac{P(spam)P(S|spam)P(C|spam \cap S)}{P(S)P(C|S)}
$$

---

* 30 emails of a total of 50 are spam
* 20 out of the total 50 contain the word SODIUM
* 15 of the emails that contain the word SODIUM are spam
* 15 out of the total 50 contain the word CHOLESTEROL
* 10 of the emails that contain the word CHOLESTEROL are spam

$$
= \frac{\frac{30}{50}P(S|spam)P(C|spam \cap S)}{P(S)P(C|S)}
$$

---

* 30 emails of a total of 50 are spam
* 20 out of the total 50 contain the word SODIUM
* 15 of the emails that contain the word SODIUM are spam
* 15 out of the total 50 contain the word CHOLESTEROL
* 10 of the emails that contain the word CHOLESTEROL are spam

$$
= \frac{\frac{30}{50}\frac{15}{30}P(C|spam \cap S)}{P(S)P(C|S)}
$$

---

* 30 emails of a total of 50 are spam
* 20 out of the total 50 contain the word SODIUM
* 15 of the emails that contain the word SODIUM are spam
* 15 out of the total 50 contain the word CHOLESTEROL
* 10 of the emails that contain the word CHOLESTEROL are spam

$$
= \frac{\frac{30}{50}\frac{15}{30}P(C|spam \cap S)}{\frac{20}{50}P(C|S)}
$$

---

# *Naive* Bayes Classifier

---

# Naive?

---

# Assume conditional independence!

---

## Assume conditional independence

$$A$$ and $$B$$ are conditionally independent.

$$
P(A|B) = P(A)
$$

---

## Assume conditional independence

$$A$$ and $$B$$ are conditionally independent.

$$
P(A|B \cap C) = P(A|C)
$$

---

[More derivation of Naive Bayes]

---

# </MATH>

---

# NSLinguisticTagger

---

* Lemmatization
* Part of speech tagging
* Language detection

