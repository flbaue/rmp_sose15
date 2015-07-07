/* Includes ------------------------------------------------------------------*/
#include "main.h"
#include <stdio.h>
#include <string.h>
#include "TI_Lib.h"
#include "tft.h"
#include "stm32f4xx.h"
#include "stm32f4xx_gpio.h"
#include "stm32f4xx_rcc.h"
#include "stringsort.h"

/* Private typedef -----------------------------------------------------------*/


/* Private define ------------------------------------------------------------*/

/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private functions ---------------------------------------------------------*/


/**
  * @brief  Main program
  * @param  None
  * @retval None
  */


  
int main(void)
{

    
  Init_TI_Board();
    

  TFT_cls();
  //TFT_puts("Hallo TI-Labor");
  TFT_carriage_return();
  TFT_newline();
    
char *pMeineStrings[] = {
    "Haller 25 EUR",
    "Kandinsky 13 EUR",
    "Brombach 5 EUR",
    "Zaluskowski 120 EUR",
    "Osman 17 EUR",
    "\0\0"
};


    printField(pMeineStrings);
    sortField(pMeineStrings);
    printf("\n");
    TFT_puts("\r\n");
    Delay(20);
    printField(pMeineStrings);
    
    return 0;

}





