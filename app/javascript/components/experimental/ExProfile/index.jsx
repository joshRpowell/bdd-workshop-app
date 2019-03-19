import React, { Suspense } from 'react';
import { Spinner } from 'reactstrap';
import { useFetch } from 'react-hooks-fetch';
import ErrorAlert from '../../ErrorAlert';

const Loading = () => (
  <Spinner color="primary" data-test-id="loading-profile" />
);

const Profile = () => {
  const url = '/api/v1/profiles';
  const player =
    localStorage.getItem('player') !== 'undefined' &&
    JSON.parse(localStorage.getItem('player'));
  const { error, data } = player
    ? useFetch(`${url}/${player.id}`)
    : [false, null];
  if (error) return <ErrorAlert errorMessage={error.message} />;
  if (!data) return null;
  return (
    <>
      <h1>Profile</h1>
      <span data-test-id="user-id">{data.id}</span>
    </>
  );
};

const ExProfile = () => (
  <main className="p-5" data-test-id="profile">
    <Suspense fallback={<Loading />}>
      <Profile />
    </Suspense>
  </main>
);

export default ExProfile;
