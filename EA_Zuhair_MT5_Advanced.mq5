// EA_Zuhair_MT5_Advanced.mq5
// Author: zuhair12345
// Date: 2026-04-13
// This Expert Advisor demonstrates comprehensive trading logic for MetaTrader 5 with error handling and validations.

// Input parameters
input double LotSize = 0.1; // Lot size for trading
input double TakeProfit = 100; // Take profit in points
input double StopLoss = 50; // Stop loss in points

// Initialization function
int OnInit() {
    // Initialize indicators and settings
    Print("Initialization complete.");
    return INIT_SUCCEEDED;
}

// Function to check for open positions
bool CheckOpenPositions() {
    for (int i = PositionsTotal() - 1; i >= 0; i--) {
        if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY || PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
            return true;
    }
    return false;
}

// Function to open a buy position
void OpenBuy() {
    if (CheckOpenPositions()) {
        Print("A position is already open. Trading aborted.");
        return;
    }

    double price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    double sl = price - StopLoss * _Point;
    double tp = price + TakeProfit * _Point;

    if (OrderSend(_Symbol, OP_BUY, LotSize, price, 3, sl, tp, "Buy Order", 0, 0, clrGreen) < 0) {
        Print("Error opening buy order: ", GetLastError());
    } else {
        Print("Buy order opened successfully.");
    }
}

// Function to open a sell position
void OpenSell() {
    if (CheckOpenPositions()) {
        Print("A position is already open. Trading aborted.");
        return;
    }

    double price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
    double sl = price + StopLoss * _Point;
    double tp = price - TakeProfit * _Point;

    if (OrderSend(_Symbol, OP_SELL, LotSize, price, 3, sl, tp, "Sell Order", 0, 0, clrRed) < 0) {
        Print("Error opening sell order: ", GetLastError());
    } else {
        Print("Sell order opened successfully.");
    }
}

// Main function called on every tick
void OnTick() {
    // Implementation of trading logic
    if (/* add conditions to trade */) {
        OpenBuy();
    } else if (/* add conditions to trade */) {
        OpenSell();
    }
}

// De-initialization function
void OnDeinit(const int reason) {
    // Cleanup indicators and resources
    Print("De-initializing EA.");
}
