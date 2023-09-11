import React, { useState } from 'react';

interface TrackingFormProps {
  onSubmit: (trackingCode: string, carrier: string) => void;
}

const TrackingForm: React.FC<TrackingFormProps> = ({ onSubmit }) => {
  const [trackingCode, setTrackingCode] = useState('');
  const [carrier, setCarrier] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onSubmit(trackingCode, carrier);
    setTrackingCode('');
    setCarrier('');
  };

  return (
    <div>
      <h2>Submit Tracking Info</h2>
      <form onSubmit={handleSubmit}>
        <div>
          <label>
            Tracking Code:
            <input
              type="text"
              value={trackingCode}
              onChange={(e) => setTrackingCode(e.target.value)}
            />
          </label>
        </div>
        <div>
          <label>
            Carrier Name:
            <input
              type="text"
              value={carrier}
              onChange={(e) => setCarrier(e.target.value)}
            />
          </label>
        </div>
        <button type="submit">Submit</button>
      </form>
    </div>
  );
};

export default TrackingForm;
