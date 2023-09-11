import React from 'react';

interface ItemListProps {
  items: string[];
}

const ItemList: React.FC<ItemListProps> = ({ items }) => {
  return (
    <div>
      <h2>Shipments List</h2>
      <ul>
        {items.map((item, index) => (
          <li key={index}>Carrier: {item.carrier_name}, Tracking ID: {item.tracking_code}, Status: {item.status}</li>
        ))}
      </ul>
    </div>
  );
};

export default ItemList;
