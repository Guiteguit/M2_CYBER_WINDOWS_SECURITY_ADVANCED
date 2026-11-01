# Security Review — M11

## 1. Surface de confiance

Identifiez :

- qui fait confiance à AD FS ;
- à quel certificat ;
- à quel endpoint ;
- à quel Realm ;
- quelles informations sont transmises.

## 2. Ce que le MFA réduit

## 3. Ce que le MFA ne résout pas

## 4. Risques de fédération

Analysez au minimum :

- IdP indisponible ;
- certificat Token-Signing compromis ;
- token volé ;
- mauvaise règle de claims ;
- mauvaise politique d'accès ;
- dépendance à un composant central.

## 5. Risques comptes privilégiés

## 6. Minimisation des claims

Quels claims sont réellement nécessaires à NovaCorp-Claims ?

Quels attributs ne devraient pas être envoyés ?

## 7. Disponibilité

Que se passe-t-il si :

- AD FS est indisponible ?
- AD DS est indisponible ?
- DNS est indisponible ?
- le certificat expire ?

## 8. Troubleshooting réalisé

Décrivez au moins un incident réellement diagnostiqué :

- symptôme ;
- dernière étape fonctionnelle ;
- hypothèses ;
- preuve ;
- cause ;
- correction ;
- retest.

## 9. Recommandations

Classez vos recommandations :

- immédiates ;
- moyen terme ;
- architecture cible.
