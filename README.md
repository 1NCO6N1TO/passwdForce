# 🔐 Script de Ataque de Fuerza Bruta con `su`

Este script de Bash te permite realizar un ataque de fuerza bruta probando una lista de contraseñas contra un usuario específico utilizando el comando `su`. Es ideal para automatizar pruebas de acceso en sistemas, mostrando una barra de progreso visual y mensajes en colores para una mejor experiencia.

## 🚀 Características

- **💥 Manejo de Ctrl+C:** El script se detiene de forma segura cuando se interrumpe con `Ctrl+C`, restaurando el cursor.
- **📊 Barra de Progreso Interactiva:** Visualiza el avance del ataque con una barra que muestra el porcentaje completado.
- **🎨 Mensajes en Colores:** Utiliza colores para mejorar la claridad de los mensajes.
- **🔍 Validación de Parámetros:** Verifica que se hayan proporcionado el nombre de usuario y el diccionario, además de asegurar que el archivo del diccionario existe.
- **⚡ Prueba Rápida de Contraseñas:** Acelera el proceso de prueba con `timeout`.

## 💡 Uso

```bash
./brute_force.sh -s <usuario> -w <diccionario>
```

- `-s <usuario>`: Nombre del usuario objetivo.
- `-w <diccionario>`: Ruta al archivo con las contraseñas.

### Ejemplo:

```bash
./brute_force.sh -s admin -w /ruta/al/diccionario.txt
```

## 🛠️ Salida

- Muestra el nombre de usuario y el archivo de diccionario.
- Calcula y muestra el número total de contraseñas.
- Imprime la contraseña actual que se está probando.
- Si se encuentra la contraseña correcta, la muestra en verde.
- Si no se encuentra ninguna contraseña válida, muestra un mensaje de error en rojo.

## 📋 Licencia

Este proyecto está bajo la [Licencia MIT](LICENSE).



### Autor: [1NCO6N1TO](https://github.com/1NCO6N1TO)



## 🛡️ Ejemplo de Ejecución

```bash
[+] Username: admin
[+] Wordlist: diccionario.txt
[+] Contraseñas a probar: 5000
[*] Iniciando ataque de fuerza bruta...
[####------------------------------] 10% (500/5000)
[*] Probando Contraseña: password123
[+] La contraseña es: password123
```


