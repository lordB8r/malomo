import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import App from './App';

describe('counter', () => {
  test('increases count by 1', async () => {
    // ARRANGE
    render(<App />);

    // ACT
    await userEvent.click(screen.getByText('count is 0'));

    // ASSERT
    expect(screen.getByRole('button', { name: /count is/ })).toHaveTextContent(
      'count is 1'
    );
  });
});
