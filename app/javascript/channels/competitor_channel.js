import consumer from "./consumer";

const initCompetitorCable = () => {
  const resultsContainer = document.getElementById('results');
  if (resultsContainer) {
    const id = resultsContainer.dataset.competitorId;

    consumer.subscriptions.create({ channel: "CompetitorChannel", id: id }, {
      received(data) {
        console.log(data); // called when data is broadcast in the cable
        resultsContainer.innerHTML = data.html ;
      },
    });
  }
  const sidebarResultsContainer = document.getElementById('sidebar-results');
  if (sidebarResultsContainer) {
    const id = sidebarResultsContainer.dataset.competitorId;

    consumer.subscriptions.create({ channel: "CompetitorChannel", id: id }, {
      received(data) {
        console.log(data); // called when data is broadcast in the cable
        sidebarResultsContainer.innerHTML = data.trading_name ;
      },
    });
  }
}

export { initCompetitorCable };
