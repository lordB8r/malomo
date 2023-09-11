import React, { useState, useEffect } from 'react';
import TrackingForm from './TrackingForm';
import ItemList from './ItemList';

const App: React.FC = () => {
  const [items, setItems] = useState<string[]>([]);
  const [successMessage, setSuccessMessage] =useState(null);

  // Function to submit tracking info to the API
  const handleSubmit = (tracking_code: string, carrier: string) => {
    // Send a POST request to your API with the tracking info
    // You need to implement this API call
    // After a successful response, you can update the list of items
    // Example:
    fetch('http://localhost:4000/api/shipment', {
      method: 'POST',
      body: JSON.stringify({ tracking_code, carrier }),
      headers: {
        'Content-Type': 'application/json',
      },
    })
    .then((response) => response.json())
    .then((data) => {
        setSuccessMessage('Form submitted successfully!');
      })
    .catch((error) => {
      console.error('Error:', error);
    });
  };

  // Function to fetch the list of items from the API
  const fetchItems = () => {
    // Send a GET request to your API to fetch items
    // You need to implement this API call
    // Example:
    fetch('http://localhost:4000/api/shipments')
    .then((response) => response.json())
    .then((data) => {
      setItems(data);
    })
    .catch((error) => {
      console.error('Error:', error);
    });
  };

  useEffect(() => {
    // Call the fetchItems function when the component mounts
    fetchItems();
  }, []);

  return (
    <div>
      {successMessage && <div className="success-message">{successMessage}</div>}
      <TrackingForm onSubmit={handleSubmit} />
      <button onClick={fetchItems}>
        Get Shipments
      </button>
      <ItemList items={items} />
    </div>
  );
};

export default App;
