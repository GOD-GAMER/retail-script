// Retail Jobs UI JavaScript
let currentScreen = 'dashboard';
let playerData = {};
let storeData = {};
let customers = [];
let currentTransaction = null;

// Initialize the UI
document.addEventListener('DOMContentLoaded', function() {
    // Listen for messages from FiveM
    window.addEventListener('message', function(event) {
        const data = event.data;
        
        switch(data.type) {
            case 'showUI':
                showUI(data.data);
                break;
            case 'hideUI':
                hideUI();
                break;
            case 'updatePlayerData':
                updatePlayerData(data.data);
                break;
            case 'updateStoreData':
                updateStoreData(data.data);
                break;
            case 'updateCustomers':
                updateCustomers(data.data);
                break;
            case 'transactionResult':
                handleTransactionResult(data.data);
                break;
        }
    });
    
    // Close UI on escape key
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            closeUI();
        }
    });
});

// UI Management Functions
function showUI(data) {
    document.getElementById('app').style.display = 'flex';
    if (data) {
        playerData = data.playerData || {};
        storeData = data.storeData || {};
    }
    updateDashboard();
}

function hideUI() {
    document.getElementById('app').style.display = 'none';
}

function closeUI() {
    hideUI();
    // Send close message to FiveM
    fetch(`https://${GetParentResourceName()}/closeUI`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({})
    });
}

function showScreen(screenName) {
    // Hide all screens
    document.querySelectorAll('.screen').forEach(screen => {
        screen.classList.remove('active');
    });
    
    // Show target screen
    document.getElementById(screenName).classList.add('active');
    currentScreen = screenName;
    
    // Initialize screen-specific data
    if (screenName === 'inventory') {
        updateInventoryDisplay();
    } else if (screenName === 'cashier') {
        updateCashierDisplay();
    } else if (screenName === 'performance') {
        updatePerformanceDisplay();
    } else if (screenName === 'training') {
        updateTrainingDisplay();
    }
}

// Dashboard Functions
function updateDashboard() {
    const rank = playerData.rank || 1;
    const experience = playerData.experience || 0;
    const earnings = playerData.earnings || 0;
    const stats = playerData.stats || {};
    
    // Update rank information
    const rankData = getRankData(rank);
    document.getElementById('current-rank').textContent = rankData.name;
    
    // Update experience progress
    const currentExp = experience;
    const nextRankExp = getRankData(rank + 1)?.required_exp || currentExp;
    const prevRankExp = rankData.required_exp;
    const progress = ((currentExp - prevRankExp) / (nextRankExp - prevRankExp)) * 100;
    
    document.getElementById('rank-progress').style.width = Math.min(progress, 100) + '%';
    document.getElementById('experience-text').textContent = `${currentExp} / ${nextRankExp} XP`;
    
    // Update other stats
    document.getElementById('daily-earnings').textContent = `$${earnings.toLocaleString()}`;
    document.getElementById('customers-served').textContent = stats.customersServed || 0;
    
    // Calculate performance rating
    const performanceRating = calculatePerformanceRating(stats);
    document.getElementById('performance-rating').textContent = `${performanceRating}%`;
    updateRatingStars(performanceRating);
}

function getRankData(rank) {
    const ranks = {
        1: { name: 'Trainee', required_exp: 0 },
        2: { name: 'Employee', required_exp: 500 },
        3: { name: 'Senior Employee', required_exp: 1500 },
        4: { name: 'Team Leader', required_exp: 3000 },
        5: { name: 'Supervisor', required_exp: 5000 },
        6: { name: 'Assistant Manager', required_exp: 8000 },
        7: { name: 'Store Manager', required_exp: 12000 },
        8: { name: 'District Manager', required_exp: 20000 },
        9: { name: 'Regional Manager', required_exp: 35000 },
        10: { name: 'CEO', required_exp: 60000 }
    };
    
    return ranks[rank] || ranks[1];
}

function calculatePerformanceRating(stats) {
    let rating = 100;
    
    // Factors that affect rating
    const customersServed = stats.customersServed || 0;
    const itemsSold = stats.itemsSold || 0;
    const totalEarnings = stats.totalEarnings || 0;
    
    // Simple performance calculation
    if (customersServed < 10) rating -= 10;
    if (itemsSold < 20) rating -= 10;
    if (totalEarnings < 500) rating -= 5;
    
    return Math.max(50, Math.min(100, rating));
}

function updateRatingStars(rating) {
    const starsElement = document.getElementById('rating-stars');
    const starCount = Math.round(rating / 20); // Convert to 1-5 stars
    
    let starsHTML = '';
    for (let i = 0; i < 5; i++) {
        if (i < starCount) {
            starsHTML += '?';
        } else {
            starsHTML += '?';
        }
    }
    
    starsElement.textContent = starsHTML;
}

// Cashier System Functions
function updateCashierDisplay() {
    requestCustomerData();
}

function requestCustomerData() {
    fetch(`https://${GetParentResourceName()}/getCustomers`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({})
    });
}

function updateCustomers(customerData) {
    customers = customerData;
    renderCustomerQueue();
}

function renderCustomerQueue() {
    const customerList = document.getElementById('customer-list');
    customerList.innerHTML = '';
    
    if (customers.length === 0) {
        customerList.innerHTML = '<div class="no-customers">No customers waiting</div>';
        return;
    }
    
    customers.forEach((customer, index) => {
        const customerElement = document.createElement('div');
        customerElement.className = 'customer-item';
        customerElement.onclick = () => selectCustomer(customer);
        
        const mood = getCustomerMood(customer.patience, customer.maxPatience);
        
        customerElement.innerHTML = `
            <div class="customer-info">
                <span class="customer-name">Customer #${index + 1}</span>
                <span class="customer-mood">${mood.emoji}</span>
            </div>
            <div class="customer-details">
                <div class="patience-bar">
                    <div class="patience-fill" style="width: ${(customer.patience / customer.maxPatience) * 100}%"></div>
                </div>
                <span class="item-count">${customer.items.length} items</span>
            </div>
        `;
        
        customerList.appendChild(customerElement);
    });
}

function getCustomerMood(patience, maxPatience) {
    const patiencePercent = (patience / maxPatience) * 100;
    
    if (patiencePercent > 70) {
        return { emoji: '??', mood: 'Happy' };
    } else if (patiencePercent > 40) {
        return { emoji: '??', mood: 'Neutral' };
    } else if (patiencePercent > 20) {
        return { emoji: '??', mood: 'Impatient' };
    } else {
        return { emoji: '??', mood: 'Angry' };
    }
}

function selectCustomer(customer) {
    currentTransaction = customer;
    renderCurrentTransaction();
    
    // Highlight selected customer
    document.querySelectorAll('.customer-item').forEach(item => {
        item.classList.remove('active');
    });
    event.currentTarget.classList.add('active');
}

function renderCurrentTransaction() {
    if (!currentTransaction) {
        document.getElementById('current-customer').innerHTML = `
            <div class="customer-info">
                <span class="customer-name">No customer selected</span>
                <span class="customer-mood">??</span>
            </div>
        `;
        document.getElementById('transaction-items').innerHTML = '';
        updateTransactionTotal(0, 0, 0);
        return;
    }
    
    const mood = getCustomerMood(currentTransaction.patience, currentTransaction.maxPatience);
    
    document.getElementById('current-customer').innerHTML = `
        <div class="customer-info">
            <span class="customer-name">Customer Transaction</span>
            <span class="customer-mood">${mood.emoji}</span>
        </div>
        <div class="customer-patience">
            <div class="patience-bar">
                <div class="patience-fill" style="width: ${(currentTransaction.patience / currentTransaction.maxPatience) * 100}%"></div>
            </div>
        </div>
    `;
    
    // Render transaction items
    const itemsContainer = document.getElementById('transaction-items');
    itemsContainer.innerHTML = '';
    
    let subtotal = 0;
    
    currentTransaction.items.forEach(item => {
        const itemElement = document.createElement('div');
        itemElement.className = 'transaction-item';
        
        const itemTotal = item.price * item.quantity;
        subtotal += itemTotal;
        
        itemElement.innerHTML = `
            <div class="item-info">
                <span class="item-name">${item.name}</span>
                <span class="item-details">Qty: ${item.quantity} @ $${item.price.toFixed(2)}</span>
            </div>
            <div class="item-total">$${itemTotal.toFixed(2)}</div>
        `;
        
        itemsContainer.appendChild(itemElement);
    });
    
    const tax = subtotal * 0.08; // 8% tax
    const total = subtotal + tax;
    
    updateTransactionTotal(subtotal, tax, total);
}

function updateTransactionTotal(subtotal, tax, total) {
    document.getElementById('subtotal').textContent = `$${subtotal.toFixed(2)}`;
    document.getElementById('tax').textContent = `$${tax.toFixed(2)}`;
    document.getElementById('total').textContent = `$${total.toFixed(2)}`;
}

function processPayment(paymentMethod) {
    if (!currentTransaction) {
        showNotification('No customer selected for transaction', 'error');
        return;
    }
    
    // Calculate service quality based on wait time
    const serviceQuality = Math.max(0.3, currentTransaction.patience / currentTransaction.maxPatience);
    
    fetch(`https://${GetParentResourceName()}/processPayment`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            customerId: currentTransaction.id,
            paymentMethod: paymentMethod,
            items: currentTransaction.items,
            serviceQuality: serviceQuality
        })
    });
}

function cancelTransaction() {
    currentTransaction = null;
    renderCurrentTransaction();
    
    // Remove active selection
    document.querySelectorAll('.customer-item').forEach(item => {
        item.classList.remove('active');
    });
}

function handleTransactionResult(result) {
    if (result.success) {
        showNotification(`Transaction completed! Earned: $${result.commission}`, 'success');
        
        // Update earnings display
        playerData.earnings = (playerData.earnings || 0) + result.commission;
        updateDashboard();
        
        // Clear transaction
        currentTransaction = null;
        renderCurrentTransaction();
        
        // Refresh customer queue
        requestCustomerData();
    } else {
        showNotification('Transaction failed: ' + result.error, 'error');
    }
}

// Inventory Management Functions
function updateInventoryDisplay() {
    requestInventoryData();
}

function requestInventoryData() {
    fetch(`https://${GetParentResourceName()}/getInventory`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({})
    });
}

function renderInventory(inventoryData) {
    const inventoryGrid = document.getElementById('inventory-grid');
    inventoryGrid.innerHTML = '';
    
    inventoryData.forEach(item => {
        const itemElement = document.createElement('div');
        itemElement.className = 'inventory-item';
        
        if (item.stock <= 5) {
            itemElement.classList.add('stock-low');
        }
        if (item.stock === 0) {
            itemElement.classList.add('stock-out');
        }
        
        itemElement.innerHTML = `
            <div class="item-name">${item.name}</div>
            <div class="item-stock">${item.stock}</div>
            <div class="item-price">$${item.price.toFixed(2)}</div>
            <div class="item-actions">
                <button class="btn primary" onclick="restockItem('${item.name}')">Restock</button>
            </div>
        `;
        
        inventoryGrid.appendChild(itemElement);
    });
}

function refreshInventory() {
    updateInventoryDisplay();
    showNotification('Inventory refreshed', 'success');
}

function searchInventory() {
    const searchTerm = document.getElementById('inventory-search').value.toLowerCase();
    const items = document.querySelectorAll('.inventory-item');
    
    items.forEach(item => {
        const itemName = item.querySelector('.item-name').textContent.toLowerCase();
        if (itemName.includes(searchTerm)) {
            item.style.display = 'block';
        } else {
            item.style.display = 'none';
        }
    });
}

function showRestockModal() {
    document.getElementById('restock-modal').style.display = 'block';
    
    // Populate item dropdown
    const select = document.getElementById('restock-item');
    select.innerHTML = '';
    
    // This would be populated with actual inventory data
    const sampleItems = ['Sandwich', 'Water', 'Energy Drink', 'Cigarettes'];
    sampleItems.forEach(item => {
        const option = document.createElement('option');
        option.value = item;
        option.textContent = item;
        select.appendChild(option);
    });
}

function closeModal(modalId) {
    document.getElementById(modalId).style.display = 'none';
}

function restockItem(itemName) {
    document.getElementById('restock-item').value = itemName;
    showRestockModal();
}

function confirmRestock() {
    const item = document.getElementById('restock-item').value;
    const quantity = parseInt(document.getElementById('restock-quantity').value);
    const cost = parseFloat(document.getElementById('restock-cost').value);
    
    if (!item || !quantity || quantity <= 0) {
        showNotification('Please fill in all fields correctly', 'error');
        return;
    }
    
    fetch(`https://${GetParentResourceName()}/restockItem`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            item: item,
            quantity: quantity,
            cost: cost
        })
    }).then(() => {
        showNotification(`Restocked ${quantity} ${item}(s)`, 'success');
        closeModal('restock-modal');
        updateInventoryDisplay();
    });
}

// Performance Analytics Functions
function updatePerformanceDisplay() {
    // This would be populated with real analytics data
    updateSalesChart();
    updateMetrics();
}

function updateSalesChart() {
    // Placeholder for chart implementation
    // You would integrate with Chart.js or similar library here
    console.log('Updating sales chart');
}

function updateMetrics() {
    // Update with real metrics
    document.getElementById('avg-transaction').textContent = '$15.50';
    document.getElementById('customer-satisfaction').textContent = '87%';
    document.getElementById('items-per-transaction').textContent = '2.3';
    document.getElementById('service-speed').textContent = 'Fast';
}

// Training System Functions
function updateTrainingDisplay() {
    // Training modules would be dynamically loaded based on player rank
    const rank = playerData.rank || 1;
    
    // Enable/disable modules based on rank
    const leadershipModule = document.querySelector('[data-module="leadership"]');
    if (rank >= 4) {
        leadershipModule.querySelector('.btn').disabled = false;
        leadershipModule.querySelector('.btn').classList.remove('disabled');
        leadershipModule.querySelector('.btn').textContent = 'Start';
        leadershipModule.querySelector('.module-progress span').textContent = 'Available';
    }
}

function startTraining(moduleType) {
    fetch(`https://${GetParentResourceName()}/startTraining`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            module: moduleType
        })
    }).then(() => {
        showNotification(`Started ${moduleType} training module`, 'success');
        closeUI();
    });
}

// Notification System
function showNotification(message, type = 'info', duration = 5000) {
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    notification.textContent = message;
    
    document.getElementById('notifications').appendChild(notification);
    
    setTimeout(() => {
        notification.style.opacity = '0';
        setTimeout(() => {
            notification.remove();
        }, 300);
    }, duration);
}

// Event Handlers for data updates
function updatePlayerData(data) {
    playerData = { ...playerData, ...data };
    updateDashboard();
}

function updateStoreData(data) {
    storeData = { ...storeData, ...data };
    if (currentScreen === 'inventory') {
        renderInventory(data.products || []);
    }
}

// Utility Functions
function GetParentResourceName() {
    return 'retail_jobs'; // This should match your resource name
}