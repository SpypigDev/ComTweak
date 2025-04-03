import { ReactNode } from 'react';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { Box, Flex, Icon, Table } from '../components';
import { DmIcon } from '../components';
import { Window } from '../layouts';

type RadarData = {
  radar_map: any;
};

const HexScrew = () => {
  return (
    <Box p="2px">
      <svg viewBox="0 0 10 10" width="30px" height="30px">
        <circle
          cx="5"
          cy="5"
          r="4"
          fill="#202020"
          stroke="#505050"
          strokeWidth="0.5"
        />
        <polygon
          points="3.5,2.5 6.5,2.5 8,5 6.5,7.5 3.5,7.5 2,5"
          fill="#040404"
        />
      </svg>
    </Box>
  );
};

const Sector = () => {
  return (
    <Box className="RadarScreen" width="100%" height="100%" mb="-100%">
      <svg width="100%" height="100%">
        <defs>
          <mask id="hole">
            <rect width="100%" height="100%" fill="green" />
            <circle r="35%" cx="50%" cy="50%" fill="black" />
          </mask>
        </defs>

        <circle
          id="donut"
          r="50%"
          cx="50%"
          cy="50%"
          mask="url(#hole)"
          fillOpacity={0}
        />
      </svg>
    </Box>
  );
};

const SwitchButton = () => {
  return (
    <Box className="RadarButtonHolder">
      <Flex height="100%">
        <Flex.Item className="RadarButton" textAlign="left">
          <Icon name="angle-left" />
        </Flex.Item>
        <Flex.Item className="RadarButtonDivider" />
        <Flex.Item className="RadarButton" textAlign="right">
          <Icon name="angle-right" />
        </Flex.Item>
      </Flex>
    </Box>
  );
};

interface ButtonProps {
  readonly children?: ReactNode;
  readonly onClick?: () => void;
}

export const VehicleRadar = (props) => {
  const { act, data } = useBackend<RadarData>();

  const topProps = props.topButtons ?? [];
  const topButtons = Array.from({ length: 5 }).map((_, i) => topProps[i] ?? {});

  return (
    <Window width={475} height={500}>
      <Window.Content className="Tester">
        <Table width="450px" height="450px" className="TesterPanel">
          <Table.Row>
            <Table.Cell>
              <HexScrew />
            </Table.Cell>
            <Table.Cell verticalAlign="top">
              <Box className="TopButtons">
                <TopButtonsPanel />
              </Box>
            </Table.Cell>
            <Table.Cell align="right">
              <HexScrew />
            </Table.Cell>
          </Table.Row>
          <Table.Row height="82%">
            <Table.Cell>
              <LeftButtonsPanel />
            </Table.Cell>
            <Table.Cell width="82%" verticalAlign="bottom">
              <VehicleRadarDebug />
            </Table.Cell>
            <Table.Cell>
              <RightButtonsPanel />
            </Table.Cell>
          </Table.Row>
          <Table.Row>
            <Table.Cell verticalAlign="bottom">
              <HexScrew />
            </Table.Cell>
            <Table.Cell className="BottomButtons">
              <BottomButtonsPanel />
            </Table.Cell>
            <Table.Cell>
              <HexScrew />
            </Table.Cell>
          </Table.Row>
        </Table>
      </Window.Content>
    </Window>
  );
};

const LeftButtonsPanel = (props) => {
  const { act, data } = useBackend<RadarData>();

  const topProps = props.topButtons ?? [];
  const topButtons = Array.from({ length: 5 }).map((_, i) => topProps[i] ?? {});

  return (
    <Box className="LeftButtons">
      <Box className="ButtonHolderL">
        <Box className="ButtonL">POWR</Box>
      </Box>
      <Box className="ButtonHolderL">
        <Box className="ButtonL">MODE</Box>
      </Box>
      <Box className="ButtonHolderL">
        <Box className="ButtonL">+</Box>
      </Box>
      <Box className="ButtonHolderL">
        <Box className="ButtonL">-</Box>
      </Box>
      <Box className="ButtonHolderL">
        <Box className="ButtonL">ZLCK</Box>
      </Box>
      <Box className="ButtonHolderL">
        <Box className="ButtonL">TLCK</Box>
      </Box>
    </Box>
  );
};

const RightButtonsPanel = (props) => {
  const { act, data } = useBackend<RadarData>();

  const topProps = props.topButtons ?? [];
  const topButtons = Array.from({ length: 5 }).map((_, i) => topProps[i] ?? {});

  return (
    <Box className="RightButtons">
      <Box className="ButtonHolderR">
        <Box className="ButtonR" onClick={() => act('blink')}>
          MPUL
        </Box>
      </Box>
      <Box className="ButtonHolderR">
        <Box className="ButtonR">APUL</Box>
      </Box>
      <Box className="ButtonHolderR">
        <Box className="ButtonR">PUL+</Box>
      </Box>
      <Box className="ButtonHolderR">
        <Box className="ButtonR">PUL-</Box>
      </Box>
      <Box className="ButtonHolderR">
        <Box className="ButtonR">CLRT</Box>
      </Box>
      <Box className="ButtonHolderR">
        <Box className="ButtonR">PROX</Box>
      </Box>
    </Box>
  );
};

const TopButtonsPanel = (props) => {
  const { act, data } = useBackend<RadarData>();

  return (
    <Flex>
      {Array.from({ length: 4 }).map((_, s) => {
        return (
          <Flex.Item mr="19px" key={s}>
            {s === 2 ? (
              <Box width="55px">radial switch here!</Box>
            ) : (
              <SwitchButton />
            )}
          </Flex.Item>
        );
      })}
    </Flex>
  );
};

const BottomButtonsPanel = (props) => {
  const { act, data } = useBackend<RadarData>();

  return (
    <Flex>
      <Flex.Item>
        <Box className="ButtonB" bold>
          MUTE
        </Box>
      </Flex.Item>
      <Flex.Item>
        <Box className="RadarButtonHolder">
          <Flex height="90%">
            <Flex.Item className="RadarButton" textAlign="left">
              <Icon name="angle-left" />
            </Flex.Item>
            <Flex.Item className="RadarButtonDivider" />
            <Flex.Item className="RadarButton" textAlign="right">
              <Icon name="angle-right" />
            </Flex.Item>
          </Flex>
        </Box>
      </Flex.Item>
    </Flex>
  );
};

const VehicleRadarDebug = (props) => {
  const { act, data } = useBackend<RadarData>();

  return (
    <Box width="100%" height="100%" className="SecondaryTesterGradient">
      <svg width={0} height={0} style={{ position: `absolute` }}>
        <defs>
          <filter id="colorMeGreen">
            <feColorMatrix
              in="SourceGraphic"
              type="matrix"
              values="-3 0 0 0 0
                0 1 0 0 0
                0 0 -1 0 0
                0 0 0 1 0 "
            />
          </filter>
        </defs>
      </svg>
      <Box
        className="SecondaryTester"
        align="center"
        fontFamily="monospace"
        bold
        textColor="green"
        width="100%"
        height="100%"
        style={{
          backgroundImage: `url(${resolveAsset(data.radar_map)})`,
          filter: `grayscale(0)` + `invert(1)` + `url(#colorMeGreen)`,
        }}
      >
        {Array.from({ length: 5 }).map((_, s) => {
          return Array.from({ length: 12 }).map((_, i) => (
            <Box
              style={{
                transform:
                  `rotate(${0 + 30 * i}deg)` + `scale(${0.3 * s}, ${0.3 * s})`,
              }}
              key={i}
            >
              <Sector />
            </Box>
          ));
        })}
        {Array.from({ length: 6 }).map((_, i) => {
          return (
            <Box
              style={{
                transform: `rotate(${0 + 30 * i}deg)`,
              }}
              key={i}
              className="RadarGrids"
            />
          );
        })}
        <DmIcon
          icon={'icons/ui_icons/map_blips_extra_large.dmi'}
          icon_state={'vtol'}
          height="64px"
          style={{ position: `absolute` }}
        />
      </Box>
    </Box>
  );
};
