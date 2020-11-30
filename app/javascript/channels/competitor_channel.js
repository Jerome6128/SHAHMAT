import consumer from "./consumer";

const initCompetitorCable = () => {
  const resultsContainer = document.getElementById('results');
  if (resultsContainer) {
    const id = resultsContainer.dataset.competitorId;

    consumer.subscriptions.create({ channel: "CompetitorChannel", id: id }, {
      received(data) {
        console.log(data); // called when data is broadcast in the cable
      },
    });
  }
}

export { initCompetitorCable };
