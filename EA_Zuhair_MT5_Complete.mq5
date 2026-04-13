// EA_Zuhair_MT5_Complete.mq5
// Comprehensive Expert Advisor for MT5

// Input parameters
input double LotSize = 0.1; // Lot size for trades
input int Slippage = 3; // Maximum allowed slippage
input double TakeProfit = 50; // Take profit in points
input double StopLoss = 50; // Stop loss in points

// Global variables
int handle; // Indicator handle
datetime lastTime = 0; // Last trade time

//+------------------------------------------------------------------+
//| Expert initialization function                                     |
//+------------------------------------------------------------------+
int OnInit()
{
    handle = iMA(NULL, 0, 14, 0, MODE_SMA, PRICE_CLOSE);
    if(handle == INVALID_HANDLE)
    {
        Print("Failed to get handle for the indicator.");
        return INIT_FAILED;
    }
    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                   |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    if(handle != INVALID_HANDLE)
    {
        IndicatorRelease(handle);
    }
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    if(!IsTradeAllowed()) return;
    CheckForTrade();
}

//+------------------------------------------------------------------+
//| Check for trade conditions                                       |
//+------------------------------------------------------------------+
void CheckForTrade()
{
    // Validate current market price
    double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    if(currentPrice == 0)
    {
        Print("Current price is invalid.");
        return;
    }

    // Get the moving average value
    double maValue = 0;
    if(!CopyBuffer(handle, 0, 0, 1, maValue))
    {
        Print("Failed to copy buffer.");
        return;
    }

    // Trading logic
    if(currentPrice > maValue)
    {
        ExecuteTrade(ORDER_BUY);
    }
    else if(currentPrice < maValue)
    {
        ExecuteTrade(ORDER_SELL);
    }
}

//+------------------------------------------------------------------+
//| Execute trade                                                   |
//+------------------------------------------------------------------+
void ExecuteTrade(int orderType)
{
    double price = 0;
    if(orderType == ORDER_BUY)
    {
        price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    }
    else if(orderType == ORDER_SELL)
    {
        price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
    }
    else return;

    if(price == 0)
    {
        Print("Invalid price for trade execution.");
        return;
    }

    double sl = (orderType == ORDER_BUY) ? price - StopLoss * Point : price + StopLoss * Point;
    double tp = (orderType == ORDER_BUY) ? price + TakeProfit * Point : price - TakeProfit * Point;

    // Send the order
    int ticket = OrderSend(_Symbol, orderType, LotSize, price, Slippage, sl, tp, NULL, 0, 0, clrNONE);
    if(ticket < 0)
    {
        Print("Failed to open order: " + GetLastError());
    }
    else
    {
        Print("Order executed successfully: Ticket #" + ticket);
    }
}

//+------------------------------------------------------------------+
//| Check if trading is allowed                                      |
//+------------------------------------------------------------------+
bool IsTradeAllowed()
{
    if(!AccountInfoInteger(ACCOUNT_TRADE_ALLOWED))
    {
        Print("Trading is not allowed on this account.");
        return false;
    }

    // Additional checks can be implemented here

    return true;
}

//+------------------------------------------------------------------+
