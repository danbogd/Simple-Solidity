pragma solidity <0.7.0;

// Пример 1 - простейшая схема try catch

contract CalledContract {    
    function someFunction() external {
        // Code that reverts
        revert();
    }
}


// try/catch доступна исключительно для внешних вызовов. Развертывание нового контракта также считается внешним вызовом.

contract TryCatcher {
    
    event CatchEvent();
    event SuccessEvent();
    
    CalledContract public externalContract;

    constructor() public {
        externalContract = new CalledContract();
    }
    
    function execute() external {
        
        try externalContract.someFunction() {
            // Do something if the call succeeds
            // Если сработало успешно
            emit SuccessEvent();
        } catch {
            // Do something in any other case
            // Если revert
            emit CatchEvent();
        }
    }
}


// Пример 2

// Ловим require, revert и их соообщения

contract CalledContract {
    
    uint public a = 2;
    uint b = 0;
    
    function someFunction() external {
        // Code that reverts
        
      require (a >3, "Это не правильно!");
      //revert("Реверт");
      //a = a/b;
    }
}




contract TryCatcher {
    
    event ReturnDataEvent(bytes someData);
    event CatchStringEvent(string REQUIRE);
    event SuccessEvent();
    
    CalledContract public externalContract;

    constructor() public {
        externalContract = new CalledContract();
    }
    
    function execute() external {
        
         try externalContract.someFunction() {
            emit SuccessEvent();
            
        // This is executed in case require and write message "Это не правильно!" or revert("Реверт"); 
        } catch Error(string memory revertReason) {
            emit CatchStringEvent(revertReason);
            
            
        // This is executed in case revert() was used  or there was a failing assertion, division by zero, etc. inside someFunction().    
        } catch (bytes memory returnData) {
            emit ReturnDataEvent(returnData);
        }
    }
        // In general, catch or catch (bytes memory returnData) must be used along with catch Error(string memory revertReason) to ensure that we are covering all possible revert causes.
}


// Пример 3
// catch (bytes memory returnData) 
// Если транзакция, выполняющая код, имеет недостаточно газа, ошибка нехватки газа не обнаруживается
// Но если мы выставим размер газа, например 20, то  недостаток газа будет выявлен.
contract CalledContract {
    
    function someFunction() public returns (uint256) {
        require(true, "This time not reverting");
    }
}

// Если блок try success выполняется, используемые возвращаемые переменные должны быть объявлены того же типа, что и переменные, фактически возвращаемые вызовом функции.

contract TryCatcher {
    
    event ReturnDataEvent(bytes someData);
    event SuccessEvent();
    event CatchStringEvent(string REQUIRE);

    CalledContract public externalContract;

    constructor() public {
        externalContract = new CalledContract();
    }
    
    function execute() public {

        try externalContract.someFunction.gas(20)() { // Setting gas to 20
           emit SuccessEvent();
           
        } catch Error(string memory revertReason) {
          emit CatchStringEvent(revertReason);
          
        } catch (bytes memory returnData) {
            emit ReturnDataEvent(returnData);
        }
    }
}