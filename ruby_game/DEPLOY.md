# Guide de déploiement sur Render.com (GRATUIT)

Ce guide vous explique comment héberger gratuitement votre application Rails Medieval RPG sur Render.com.

## 📋 Prérequis

1. Un compte GitHub (gratuit)
2. Un compte Render.com (gratuit) - [S'inscrire ici](https://render.com)
3. Votre projet doit être poussé sur GitHub

## 🚀 Étapes de déploiement

### 1. Préparer votre projet sur GitHub

Assurez-vous que votre code est sur GitHub :

```bash
# Si ce n'est pas déjà fait, initialisez git et poussez votre code
cd medieval_rpg
git add .
git commit -m "Préparation pour déploiement Render"
git push origin main
```

### 2. Créer un compte Render.com

1. Allez sur [render.com](https://render.com)
2. Cliquez sur "Get Started for Free"
3. Connectez-vous avec votre compte GitHub

### 3. Créer la base de données PostgreSQL

1. Dans le dashboard Render, cliquez sur **"New +"** → **"PostgreSQL"**
2. Configurez :
   - **Name**: `medieval-rpg-db`
   - **Database**: `medieval_rpg_production`
   - **User**: `medieval_rpg`
   - **Plan**: **Free** (gratuit)
   - **Region**: Choisissez la région la plus proche (ex: Frankfurt, Ireland)
3. Cliquez sur **"Create Database"**
4. **Important** : Notez les informations de connexion (Internal Database URL) qui apparaîtront

### 4. Créer le service Web

1. Dans le dashboard Render, cliquez sur **"New +"** → **"Web Service"**
2. Connectez votre repository GitHub :
   - Sélectionnez votre repository `W-WEB-330-PAR-4-1-ruby-yousra.belbaz`
   - Cliquez sur **"Connect"**
3. Configurez le service :
   - **Name**: `medieval-rpg`
   - **Environment**: **Ruby**
   - **Region**: Même région que la base de données
   - **Branch**: `main` (ou votre branche principale)
   - **Root Directory**: `medieval_rpg` (important !)
   - **Build Command**: `./bin/render-build.sh`
   - **Start Command**: `./bin/render-start.sh`
   - **Plan**: **Free** (gratuit)

### 5. Configurer les variables d'environnement

Dans la section **"Environment"** du service web, ajoutez :

1. **RAILS_MASTER_KEY** :

   - Cliquez sur **"Add Environment Variable"**
   - Key: `RAILS_MASTER_KEY`
   - Value: Copiez le contenu de `config/master.key` (sur votre machine locale)
   - Cliquez sur **"Save Changes"**

2. **RAILS_ENV** :

   - Key: `RAILS_ENV`
   - Value: `production`

3. **DATABASE_URL** :

   - Key: `DATABASE_URL`
   - Value: Copiez l'**Internal Database URL** de votre base de données PostgreSQL créée à l'étape 3
   - (Format: `postgresql://medieval_rpg:password@dpg-xxxxx-a/medieval_rpg_production`)

4. **RAILS_SERVE_STATIC_FILES** :

   - Key: `RAILS_SERVE_STATIC_FILES`
   - Value: `true`

5. **RAILS_LOG_TO_STDOUT** :
   - Key: `RAILS_LOG_TO_STDOUT`
   - Value: `true`

### 6. Déployer

1. Cliquez sur **"Create Web Service"**
2. Render va automatiquement :

   - Cloner votre code
   - Installer les dépendances Ruby et Node.js
   - Compiler les assets
   - Créer et migrer la base de données
   - Démarrer votre application

3. Le déploiement prend environ 5-10 minutes la première fois

### 7. Accéder à votre application

Une fois le déploiement terminé, vous obtiendrez une URL comme :

```
https://medieval-rpg.onrender.com
```

Votre application sera accessible à cette adresse ! 🎉

## 🔧 Dépannage

### L'application ne démarre pas

1. Vérifiez les logs dans le dashboard Render (onglet "Logs")
2. Vérifiez que toutes les variables d'environnement sont correctement configurées
3. Vérifiez que `RAILS_MASTER_KEY` correspond bien à votre fichier `config/master.key`

### Erreur de base de données

1. Vérifiez que `DATABASE_URL` est correctement configuré
2. Vérifiez que la base de données est bien créée et active
3. Les migrations s'exécutent automatiquement au démarrage grâce à `db:prepare`

### Erreur de build

1. Vérifiez que le **Root Directory** est bien `medieval_rpg`
2. Vérifiez que les scripts `bin/render-build.sh` et `bin/render-start.sh` sont exécutables
3. Consultez les logs de build pour plus de détails

## 📝 Notes importantes

- **Plan gratuit** : L'application se met en veille après 15 minutes d'inactivité. Le premier chargement après veille peut prendre 30-60 secondes.
- **Base de données gratuite** : Limite de 90 jours, puis vous devrez peut-être passer à un plan payant ou exporter vos données.
- **Déploiements automatiques** : Chaque push sur la branche `main` déclenchera un nouveau déploiement automatiquement.

## 🔄 Mettre à jour l'application

Pour mettre à jour votre application :

```bash
git add .
git commit -m "Vos modifications"
git push origin main
```

Render détectera automatiquement le changement et redéploiera l'application.

## 🌐 Alternatives gratuites

Si Render ne vous convient pas, voici d'autres options gratuites :

1. **Railway.app** - Offre des crédits gratuits chaque mois
2. **Fly.io** - Plan gratuit avec limitations
3. **Heroku** - Plus de plan gratuit, mais offre des crédits étudiants

---

**Besoin d'aide ?** Consultez la [documentation Render](https://render.com/docs) ou les logs de votre application.
