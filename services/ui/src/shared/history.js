import {browserHistory, createMemoryHistory} from 'react-router'

const history = (__SERVER__) ? createMemoryHistory() : browserHistory
export default history;
