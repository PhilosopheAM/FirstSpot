import {Composition} from 'remotion';

import {CatWave} from './CatWave';

export const Root = () => {
  return (
    <Composition
      id="CatWave"
      component={CatWave}
      durationInFrames={60}
      fps={30}
      width={512}
      height={512}
    />
  );
};
