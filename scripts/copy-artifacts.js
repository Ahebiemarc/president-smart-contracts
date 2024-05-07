const fs = require("fs-extra"); // fs-extra pour copier des répertoires
const path = require("path");

// Chemin vers le répertoire source artifacts dans ce projet
const artifactsSourcePath = path.join(__dirname, '..', 'artifacts');

// Chemin vers le répertoire de destination dans le projet (API) Node.js ts
const artifactsDestPath = path.join(__dirname, '..', '..', 'monpresident_api', 'src', 'config', 'artifacts');

fs.copy(artifactsSourcePath, artifactsDestPath, (err) =>{
    if (err) return console.error('Error copying artifacts:', err);
    console.log("Artifacts copied successfully to ", artifactsDestPath);
})




