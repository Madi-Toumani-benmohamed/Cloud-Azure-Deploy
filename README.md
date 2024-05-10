# Déploiement d'une machine virtuelle sur Azure avec Terraform

Ce projet permet le déploiement automatique d'une machine virtuelle sur Microsoft Azure en utilisant Terraform. Vous pouvez rapidement provisionner et gérer une machine virtuelle sur Azure en définissant simplement les configurations nécessaires dans Terraform.
Prérequis

Avant de commencer, assurez-vous d'avoir les éléments suivants :

    Terraform installé localement. Vous pouvez trouver des instructions d'installation sur le site officiel de Terraform.
    Un compte Azure actif avec les informations d'identification nécessaires pour vous connecter à votre abonnement Azure.
    Les droits d'accès nécessaires pour créer des ressources dans votre abonnement Azure.

# Utilisation
Configuration des informations d'identification Azure

Avant de pouvoir utiliser Terraform pour déployer des ressources sur Azure, vous devez configurer vos informations d'identification Azure. Vous pouvez le faire en utilisant Azure CLI et en exécutant la commande suivante :

```sh

az login
```


Suivez les instructions pour vous connecter à votre compte Azure.
Configuration de Terraform

    Clonez ce dépôt sur votre machine locale :


git clone 



Modifiez le fichier variables.tf pour configurer les variables Terraform nécessaires, telles que le nom de la machine virtuelle, le type d'instance, etc.

Initialisez Terraform pour installer les modules nécessaires :

```sh
terraform init
```



Exécutez Terraform pour planifier et appliquer les changements :

```sh
    terraform plan
    terraform apply
```



Après avoir confirmé, Terraform commencera à provisionner la machine virtuelle sur Azure en fonction des configurations spécifiées.

# Nettoyage

Après avoir terminé l'utilisation de la machine virtuelle, vous pouvez supprimer les ressources Azure créées en exécutant la commande Terraform suivante :

```sh
terraform destroy
```
