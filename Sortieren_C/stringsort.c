#include "stringsort.h"

/**
  * @brief  printField gibt eine Liste von Strings zeilenweise auf der Konsole aus
  * @param  pointer auf eine Liste von Strings
  */
void printField(char *liste[]) {
    int i = 0;
    int r = strncmp(liste[i],"\0\0", 2);
    while (r != 0) {
        printf("%s\n",liste[i]);
        Delay(20);
        TFT_puts(liste[i]);
        TFT_puts("\r\n");
        i += 1;
        r = strncmp(liste[i],"\0\0", 2);
    }
}

/**
  * @brief  getNum extrahiert einen Zahlenwert aus einem gegebenen String
  * @param  pointer auf einen string
  * @retval der Wert als integer
  */
int getNum(char *line) {
    
    int i = 0;
    char currentChar;
    int x = 0;
    do {
        currentChar = line[i];
        if(currentChar >= 0x30 && currentChar <= 0x39) {
                x = x * 10 + (currentChar - 0x30);
        }
        
    i += 1;
    } while (currentChar != '\0');
    
    return x;
}

/**
  * @brief  sortField sortiert eine liste von strings
  * @param  pointer auf eine liste von strings. (Die liste wird verändert)
  */
void sortField(char *liste[]) {
    
    int switched = 1;
    while(switched) {
        switched = 0;
        int a = 0;
        
        char *p1 = liste[a];
        while (strncmp(liste[a+1],"\0\0", 2) != 0) {
            char *p2 = liste[a+1];
            
            if(getNum(p1) > getNum_asm(p2)) {
                
                liste[a] = liste[a+1];
                liste[a+1] = p1;
                switched = 1;
            }
            p1 = liste[++a];
        }
    }
    
}


