# Vault
# @version 0.3.9
"""
@title ETH Vault
@author Patrick Collins
"""

owner: public(address)
address_to_amount_deposited: public(HashMap[address, uint256])

@external
def __init__():
    self.owner = msg.sender

@external
@payable
def deposit():
    self.address_to_amount_deposited[msg.sender] = msg.value


@external
@payable
def withdraw(amount_to_withdraw: uint256):
    """
    We withdraw funds, on a tier system. The more money withdrawn, the cheaper fees. 
    """    
    current_balance: uint256 = self.address_to_amount_deposited[msg.sender]
    fee_percentage: uint256 = 5 
    if (amount_to_withdraw > 100 * (10 ** 18)):
        fee_percentage = 4 
    elif (amount_to_withdraw > 10 * (10 ** 18)):
        fee_percentage = 100  # The bug is here 
    elif (amount_to_withdraw > 1 * (10 ** 18)):
        fee_percentage = 2 
    else:
        fee_percentage = 1 
    fee: uint256 = current_balance * fee_percentage / 100
    assert current_balance > 0
    assert current_balance >= amount_to_withdraw 
    self.address_to_amount_deposited[msg.sender] = current_balance - amount_to_withdraw
    send(msg.sender, amount_to_withdraw - fee)
    send(self.owner, fee)
